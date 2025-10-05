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
                    forceReload = UUID()  // Force reload to apply new settings
                }
            }
            .padding()
            
            // Only show inline WebView if not using fullscreen mode.
            if !settings.isFullscreen {
                WebView(url: $currentURL, settings: settings)
                    .id(forceReload)
            } else {
                VStack {
                    Text("Load in Fullscreen WebView")
                    Button("Open Fullscreen") {
                        forceReload = UUID()
                    }
                }
            }
        }
        // Fullscreen cover for the web view.
        .sheet(isPresented: $settings.isFullscreen) {
            NavigationView {
                WebView(url: $currentURL, settings: settings)
                    .id(forceReload)
                    .edgesIgnoringSafeArea(.all)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                settings.isFullscreen = false
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
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "local")
        
        // Apply JavaScript settings using modern API
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = settings.javaScriptEnabled
        configuration.defaultWebpagePreferences = preferences
        
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.javaScriptCanOpenWindowsAutomatically
        
        // Apply media settings
        configuration.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback
        configuration.mediaTypesRequiringUserActionForPlayback = settings.mediaTypesRequiringUserAction ? .all : []
        configuration.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback
        
        // Apply content settings
        configuration.suppressesIncrementalRendering = settings.suppressesIncrementalRendering
        configuration.ignoresViewportScaleLimits = settings.ignoresViewportScaleLimits
        
        // Apply AirPlay setting
        configuration.allowsAirPlayForMediaPlayback = settings.allowsAirPlayForMediaPlayback
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        context.coordinator.settings = settings
        
        // Apply interaction settings
        webView.allowsLinkPreview = settings.allowsLinkPreview
        webView.allowsBackForwardNavigationGestures = settings.allowsBackForwardNavigationGestures
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update coordinator settings reference
        context.coordinator.settings = settings
        
        // Update settings that can be changed dynamically
        uiView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.javaScriptCanOpenWindowsAutomatically
        uiView.allowsLinkPreview = settings.allowsLinkPreview
        uiView.allowsBackForwardNavigationGestures = settings.allowsBackForwardNavigationGestures
        
        // Load URL if changed
        guard uiView.url != url else { return }
        uiView.load(URLRequest(url: url))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var currentURL: URL?
        var settings: AppSettings?
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            // Apply JavaScript setting per navigation using modern API
            if let settings = settings {
                preferences.allowsContentJavaScript = settings.javaScriptEnabled
            }
            decisionHandler(.allow, preferences)
        }
    }
}
