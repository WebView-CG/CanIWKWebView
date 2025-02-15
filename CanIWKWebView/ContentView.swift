//
//  ContentView.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 01.02.25.
//

import SwiftUI
import WebKit

// MARK: - WebView (Tab 1)

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




struct WebView: UIViewRepresentable {
    @Binding var url: URL
    private let configuration = WKWebViewConfiguration()
    
    func makeUIView(context: Context) -> WKWebView {
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



// MARK: - ConfigView (Tab 2)

struct ConfigTab: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Fullscreen WebView", isOn: $settings.isFullscreen)
                }
            }
            .navigationTitle("Config")
        }
    }
}


// MARK: - TabView

struct ContentView: View {
    @StateObject var appSettings = AppSettings()
    
    var body: some View {
        TabView {
            WebViewTab()
                .tabItem {
                    Image(systemName: "safari")
                    Text("WebView")
                }
                .environmentObject(appSettings)
            ConfigTab()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Config")
                }
                .environmentObject(appSettings)
        }
    }
}

