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
            }
            .padding()
            
            // Only show inline WebView if not using fullscreen mode.
            if !settings.isFullscreen {
                WebView(url: $currentURL)
                    .id(forceReload)
            } else {
                Text("Load in Fullscreen WebView")
            }
        }
        // Fullscreen cover for the web view.
        .fullScreenCover(isPresented: $showFullScreen) {
            NavigationView {
                WebView(url: $currentURL)
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

#if os(macOS)
struct WebView: NSViewRepresentable {
    @Binding var url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "local")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard nsView.url != url else { return }
        nsView.load(URLRequest(url: url))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var currentURL: URL?
    }
}
#else
struct WebView: UIViewRepresentable {
    @Binding var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "local")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard uiView.url != url else { return }
        uiView.load(URLRequest(url: url))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var currentURL: URL?
    }
}
#endif
