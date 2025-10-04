//
//  ContentView.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 01.02.25.
//

import SwiftUI

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

