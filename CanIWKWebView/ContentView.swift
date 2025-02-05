//
//  ContentView.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 01.02.25.
//

import SwiftUI
import WebKit

// MARK: - WebView (Tab 1)

/// Diese SwiftUI-Wrapper-Struktur bettet einen WKWebView ein.
struct WebViewTab: UIViewRepresentable {
    let url: URL

    // Erstellt den WKWebView und lädt die URL.
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "local")
        
        // TODO implement config
        // Cordova https://github.com/apache/cordova-ios/blob/master/CordovaLib/Classes/Private/Plugins/CDVWebViewEngine/CDVWebViewEngine.m#L78
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    // Aktualisierungen am UIView (falls nötig).
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Hier kannst du den WebView bei Bedarf aktualisieren.
    }
}

// MARK: - ConfigView (Tab 2)

/// Diese Ansicht zeigt einfache Konfigurationseinstellungen.
struct ConfigTab: View {
    // Beispielhafte Zustandsvariablen für Toggle-Optionen
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

// MARK: - ContentView mit TabView

/// Hauptansicht mit einem TabView, das zwei Tabs bereitstellt.
struct ContentView: View {
    var body: some View {
        TabView {
            // Erster Tab: WebView
            WebViewTab(url: URL(string: "local://index.html")!)
                .tabItem {
                    Image(systemName: "safari") // Symbol aus SF Symbols
                    Text("WebView")
                }
            
            // Zweiter Tab: Config
            ConfigTab()
                .tabItem {
                    Image(systemName: "gear") // Symbol aus SF Symbols
                    Text("Config")
                }
        }
    }
}
