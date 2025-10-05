//
//  ConfigTab.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 01.02.25.
//

import SwiftUI
import WebKit

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
                
                Picker("Data Detector Types", selection: $settings.dataDetectorTypes) {
                    Text("None").tag(UInt(0))
                    Text("Phone Numbers").tag(WKDataDetectorTypes.phoneNumber.rawValue)
                    Text("Links").tag(WKDataDetectorTypes.link.rawValue)
                    Text("Addresses").tag(WKDataDetectorTypes.address.rawValue)
                    Text("Calendar Events").tag(WKDataDetectorTypes.calendarEvent.rawValue)
                    Text("Tracking Numbers").tag(WKDataDetectorTypes.trackingNumber.rawValue)
                    Text("Flight Numbers").tag(WKDataDetectorTypes.flightNumber.rawValue)
                    Text("Lookup Suggestions").tag(WKDataDetectorTypes.lookupSuggestion.rawValue)
                    Text("All").tag(WKDataDetectorTypes.all.rawValue)
                }
                
                Picker("Preferred Content Mode", selection: $settings.preferredContentMode) {
                    Text("Recommended").tag(0)
                    Text("Mobile").tag(1)
                    Text("Desktop").tag(2)
                }
            }
            
            Section(header: Text("Security & Privacy")) {
                Toggle("Fraudulent Website Warning", isOn: $settings.isFraudulentWebsiteWarningEnabled)
                Toggle("Limit to App-Bound Domains", isOn: $settings.limitsNavigationsToAppBoundDomains)
                Toggle("Upgrade Known Hosts to HTTPS", isOn: $settings.upgradeKnownHostsToHTTPS)
            }
            
            Section(header: Text("Interaction")) {
                Toggle("Link Preview", isOn: $settings.allowsLinkPreview)
                Toggle("Swipe Navigation Gestures", isOn: $settings.allowsBackForwardNavigationGestures)
            }
            
            Section(header: Text("Text & Typography")) {
                Toggle("Text Interaction Enabled", isOn: $settings.isTextInteractionEnabled)
                
                HStack {
                    Text("Minimum Font Size")
                    Spacer()
                    TextField("0", value: $settings.minimumFontSize, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                }
            }
            
            Section(header: Text("Advanced Settings")) {
                Toggle("Print Backgrounds", isOn: $settings.shouldPrintBackgrounds)
                Toggle("Element Fullscreen Enabled", isOn: $settings.isElementFullscreenEnabled)
                Toggle("Site-Specific Quirks Mode", isOn: $settings.isSiteSpecificQuirksModeEnabled)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Custom User Agent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Leave empty for default", text: $settings.customUserAgent)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Application Name for User Agent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Leave empty for default", text: $settings.applicationNameForUserAgent)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                }
            }
        }
        .navigationTitle("WebView Configuration")
    }
}
