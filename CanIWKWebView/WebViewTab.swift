//
//  WebViewTab.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 01.02.25.
//

import SwiftUI
import WebKit

struct WebViewTab: View {
    @State private var currentURL: URL
    @State private var forceReload = UUID()  // Used to force view reload
    @State private var showFullScreen: Bool = false

    @EnvironmentObject var settings: AppSettings
    
    init() {
        _currentURL = State(initialValue: URL(string: "local://index.html")!)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter URL", text: $settings.urlString)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("Load") {
                    guard let url = URL(string: settings.urlString) else {
                        print("Invalid URL")
                        return
                    }
                    currentURL = url
                    if settings.isFullscreen {
                        showFullScreen = true
                    } else {
                        forceReload = UUID()  // Reload inline WebView
                    }
                }
                
                Button(action: {
                    let homeURL = URL(string: "local://index.html")!
                    settings.urlString = "local://index.html"
                    currentURL = homeURL
                    if settings.isFullscreen {
                        showFullScreen = true
                    } else {
                        forceReload = UUID()  // Reload inline WebView
                    }
                }) {
                    Image(systemName: "house.fill")
                }
            }
            .padding()
            
            // Only show inline WebView if not using fullscreen mode.
            if !settings.isFullscreen {
                WebView(url: $currentURL, settings: settings)
                    .id(forceReload)
            } else {
                Text("Load in Fullscreen WebView")
            }
        }
        // Fullscreen cover for the web view.
        .fullScreenCover(isPresented: $showFullScreen) {
            NavigationView {
                WebView(url: $currentURL, settings: settings)
                    .edgesIgnoringSafeArea(.all)
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Done") {
                                showFullScreen = false
                            }
                        }
                    }
            }
        }
    }
    
    private func formatURL(_ input: String) -> URL? {
        return URL(string: input)
    }
}

struct WebView: UIViewRepresentable {
    @Binding var url: URL
    @ObservedObject var settings: AppSettings
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "local")
        
        // Apply JavaScript settings using modern API
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = settings.javaScriptEnabled
        preferences.preferredContentMode = WKWebpagePreferences.ContentMode(rawValue: settings.preferredContentMode) ?? .recommended
        configuration.defaultWebpagePreferences = preferences
        
        // WKPreferences settings
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.javaScriptCanOpenWindowsAutomatically
        configuration.preferences.minimumFontSize = settings.minimumFontSize
        configuration.preferences.isFraudulentWebsiteWarningEnabled = settings.isFraudulentWebsiteWarningEnabled
        configuration.preferences.isTextInteractionEnabled = settings.isTextInteractionEnabled
        configuration.preferences.shouldPrintBackgrounds = settings.shouldPrintBackgrounds
        configuration.preferences.isElementFullscreenEnabled = settings.isElementFullscreenEnabled
        configuration.preferences.isSiteSpecificQuirksModeEnabled = settings.isSiteSpecificQuirksModeEnabled
        
        // Media settings
        configuration.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback
        configuration.mediaTypesRequiringUserActionForPlayback = settings.mediaTypesRequiringUserAction ? .all : []
        configuration.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback
        configuration.allowsAirPlayForMediaPlayback = settings.allowsAirPlayForMediaPlayback
        
        // Content & rendering settings
        configuration.suppressesIncrementalRendering = settings.suppressesIncrementalRendering
        configuration.ignoresViewportScaleLimits = settings.ignoresViewportScaleLimits
        configuration.dataDetectorTypes = WKDataDetectorTypes(rawValue: settings.dataDetectorTypes)
        
        // Security & privacy settings
        configuration.limitsNavigationsToAppBoundDomains = settings.limitsNavigationsToAppBoundDomains
        configuration.upgradeKnownHostsToHTTPS = settings.upgradeKnownHostsToHTTPS
        
        // User agent settings
        if !settings.applicationNameForUserAgent.isEmpty {
            configuration.applicationNameForUserAgent = settings.applicationNameForUserAgent
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = context.coordinator
        
        // Apply interaction settings
        webView.allowsLinkPreview = settings.allowsLinkPreview
        webView.allowsBackForwardNavigationGestures = settings.allowsBackForwardNavigationGestures
        
        // Apply custom user agent if set
        if !settings.customUserAgent.isEmpty {
            webView.customUserAgent = settings.customUserAgent
        }

        // Enable inspectable web view in debug mode for testing and automations
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update settings that can be changed dynamically
        uiView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.javaScriptCanOpenWindowsAutomatically
        uiView.configuration.preferences.minimumFontSize = settings.minimumFontSize
        uiView.configuration.preferences.isFraudulentWebsiteWarningEnabled = settings.isFraudulentWebsiteWarningEnabled
        uiView.configuration.preferences.isTextInteractionEnabled = settings.isTextInteractionEnabled
        uiView.configuration.preferences.shouldPrintBackgrounds = settings.shouldPrintBackgrounds
        uiView.configuration.preferences.isElementFullscreenEnabled = settings.isElementFullscreenEnabled
        uiView.configuration.preferences.isSiteSpecificQuirksModeEnabled = settings.isSiteSpecificQuirksModeEnabled
        
        uiView.allowsLinkPreview = settings.allowsLinkPreview
        uiView.allowsBackForwardNavigationGestures = settings.allowsBackForwardNavigationGestures
        
        // Update custom user agent
        if settings.customUserAgent.isEmpty {
            uiView.customUserAgent = nil
        } else {
            uiView.customUserAgent = settings.customUserAgent
        }
        
        // Load URL if changed
        guard uiView.url != url else { return }
        uiView.load(URLRequest(url: url))
    }
    
    class Coordinator: NSObject, WKUIDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let frame = navigationAction.targetFrame,
                frame.isMainFrame {
                return nil
            }
            webView.load(navigationAction.request)
            return nil
        }
    }
}
