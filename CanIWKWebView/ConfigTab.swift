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
        }
    }
}
