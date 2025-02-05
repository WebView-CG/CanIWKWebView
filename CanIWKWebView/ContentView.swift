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
    @State private var urlInput = "local://index.html"
    @State private var currentURL: URL
    @State private var forceReload = UUID()  // Force view recreation
    
    init() {
        _currentURL = State(initialValue: URL(string: "local://index.html")!)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter URL", text: $urlInput)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("Load") {
                    guard let url = formatURL(urlInput) else {
                        print("Invalid URL")
                        return
                    }
                    currentURL = url
                    forceReload = UUID()  // Trigger view recreation
                }
            }
            .padding()
            
            WebView(url: $currentURL)
                .id(forceReload)  // Force view recreation on URL change
        }
    }
    
    private func formatURL(_ input: String) -> URL? {
        //let formatted = input.hasPrefix("http") ? input : "http://\(input)"
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
   @State private var option1: Bool = true
    @State private var option2: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Einstellungen")) {
                    Toggle("Option 1", isOn: $option1)
                    Toggle("Option 2", isOn: $option2)
                }
            }
            .navigationTitle("Config")
        }
    }
}

// MARK: - TabView

struct ContentView: View {
    var body: some View {
        TabView {
            WebViewTab()
                .tabItem {
                    Image(systemName: "safari")
                    Text("WebView")
                }
            ConfigTab()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Config")
                }
        }
    }
}
