//
//  ConfigTab.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 01.02.25.
//

import SwiftUI

struct ConfigTab: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Fullscreen WebView", isOn: $settings.isFullscreen)
            }
            
            Section(header: Text("JavaScript")) {
                Toggle("JavaScript Enabled", isOn: $settings.javaScriptEnabled)
                Toggle("Can Open Windows Automatically", isOn: $settings.javaScriptCanOpenWindowsAutomatically)
                    .disabled(!settings.javaScriptEnabled)
            }
            
            Section(header: Text("Media Playback")) {
                Toggle("Inline Media Playback", isOn: $settings.allowsInlineMediaPlayback)
                Toggle("Require User Action for Media", isOn: $settings.mediaTypesRequiringUserAction)
                Toggle("Picture in Picture", isOn: $settings.allowsPictureInPictureMediaPlayback)
                Toggle("AirPlay for Media", isOn: $settings.allowsAirPlayForMediaPlayback)
            }
            
            Section(header: Text("Content & Rendering")) {
                Toggle("Suppress Incremental Rendering", isOn: $settings.suppressesIncrementalRendering)
                Toggle("Ignore Viewport Scale Limits", isOn: $settings.ignoresViewportScaleLimits)
            }
            
            Section(header: Text("Interaction")) {
                Toggle("Link Preview", isOn: $settings.allowsLinkPreview)
                Toggle("Swipe Navigation Gestures", isOn: $settings.allowsBackForwardNavigationGestures)
            }
        }
        .navigationTitle("WebView Configuration")
    }
}
