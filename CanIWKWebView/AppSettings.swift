//
//  AppSettings.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 15.02.25.
//

import Foundation
import WebKit

class AppSettings: ObservableObject {
    @Published var isFullscreen: Bool {
        didSet {
            UserDefaults.standard.set(isFullscreen, forKey: "isFullscreen")
        }
    }
    
    @Published var urlString: String {
        didSet {
            UserDefaults.standard.set(urlString, forKey: "urlString")
        }
    }
    
    // MARK: - JavaScript & Content Settings
    @Published var javaScriptEnabled: Bool {
        didSet {
            UserDefaults.standard.set(javaScriptEnabled, forKey: "javaScriptEnabled")
        }
    }
    
    @Published var javaScriptCanOpenWindowsAutomatically: Bool {
        didSet {
            UserDefaults.standard.set(javaScriptCanOpenWindowsAutomatically, forKey: "javaScriptCanOpenWindowsAutomatically")
        }
    }
    
    // MARK: - Media Playback Settings
    @Published var allowsInlineMediaPlayback: Bool {
        didSet {
            UserDefaults.standard.set(allowsInlineMediaPlayback, forKey: "allowsInlineMediaPlayback")
        }
    }
    
    @Published var mediaTypesRequiringUserAction: Bool {
        didSet {
            UserDefaults.standard.set(mediaTypesRequiringUserAction, forKey: "mediaTypesRequiringUserAction")
        }
    }
    
    @Published var allowsPictureInPictureMediaPlayback: Bool {
        didSet {
            UserDefaults.standard.set(allowsPictureInPictureMediaPlayback, forKey: "allowsPictureInPictureMediaPlayback")
        }
    }
    
    @Published var allowsAirPlayForMediaPlayback: Bool {
        didSet {
            UserDefaults.standard.set(allowsAirPlayForMediaPlayback, forKey: "allowsAirPlayForMediaPlayback")
        }
    }
    
    // MARK: - Content & Rendering Settings
    @Published var suppressesIncrementalRendering: Bool {
        didSet {
            UserDefaults.standard.set(suppressesIncrementalRendering, forKey: "suppressesIncrementalRendering")
        }
    }
    
    @Published var ignoresViewportScaleLimits: Bool {
        didSet {
            UserDefaults.standard.set(ignoresViewportScaleLimits, forKey: "ignoresViewportScaleLimits")
        }
    }
    
    @Published var dataDetectorTypes: UInt {
        didSet {
            UserDefaults.standard.set(dataDetectorTypes, forKey: "dataDetectorTypes")
        }
    }
    
    // MARK: - Security & Privacy Settings
    @Published var limitsNavigationsToAppBoundDomains: Bool {
        didSet {
            UserDefaults.standard.set(limitsNavigationsToAppBoundDomains, forKey: "limitsNavigationsToAppBoundDomains")
        }
    }
    
    @Published var upgradeKnownHostsToHTTPS: Bool {
        didSet {
            UserDefaults.standard.set(upgradeKnownHostsToHTTPS, forKey: "upgradeKnownHostsToHTTPS")
        }
    }
    
    @Published var isFraudulentWebsiteWarningEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isFraudulentWebsiteWarningEnabled, forKey: "isFraudulentWebsiteWarningEnabled")
        }
    }
    
    // MARK: - Interaction Settings
    @Published var allowsLinkPreview: Bool {
        didSet {
            UserDefaults.standard.set(allowsLinkPreview, forKey: "allowsLinkPreview")
        }
    }
    
    @Published var allowsBackForwardNavigationGestures: Bool {
        didSet {
            UserDefaults.standard.set(allowsBackForwardNavigationGestures, forKey: "allowsBackForwardNavigationGestures")
        }
    }
    
    // MARK: - Text & Typography Settings
    @Published var minimumFontSize: Double {
        didSet {
            UserDefaults.standard.set(minimumFontSize, forKey: "minimumFontSize")
        }
    }
    
    @Published var isTextInteractionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isTextInteractionEnabled, forKey: "isTextInteractionEnabled")
        }
    }
    
    // MARK: - Advanced Settings
    @Published var shouldPrintBackgrounds: Bool {
        didSet {
            UserDefaults.standard.set(shouldPrintBackgrounds, forKey: "shouldPrintBackgrounds")
        }
    }
    
    @Published var isElementFullscreenEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isElementFullscreenEnabled, forKey: "isElementFullscreenEnabled")
        }
    }
    
    @Published var isSiteSpecificQuirksModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSiteSpecificQuirksModeEnabled, forKey: "isSiteSpecificQuirksModeEnabled")
        }
    }
    
    @Published var customUserAgent: String {
        didSet {
            UserDefaults.standard.set(customUserAgent, forKey: "customUserAgent")
        }
    }
    
    @Published var applicationNameForUserAgent: String {
        didSet {
            UserDefaults.standard.set(applicationNameForUserAgent, forKey: "applicationNameForUserAgent")
        }
    }
    
    @Published var preferredContentMode: Int {
        didSet {
            UserDefaults.standard.set(preferredContentMode, forKey: "preferredContentMode")
        }
    }
    
    init() {
        self.isFullscreen = UserDefaults.standard.object(forKey: "isFullscreen") as? Bool ?? false
        self.urlString = UserDefaults.standard.object(forKey: "urlString") as? String ?? "local://index.html"
        
        // JavaScript Settings - defaults to enabled
        self.javaScriptEnabled = UserDefaults.standard.object(forKey: "javaScriptEnabled") as? Bool ?? true
        self.javaScriptCanOpenWindowsAutomatically = UserDefaults.standard.object(forKey: "javaScriptCanOpenWindowsAutomatically") as? Bool ?? false
        
        // Media Settings
        self.allowsInlineMediaPlayback = UserDefaults.standard.object(forKey: "allowsInlineMediaPlayback") as? Bool ?? true
        self.mediaTypesRequiringUserAction = UserDefaults.standard.object(forKey: "mediaTypesRequiringUserAction") as? Bool ?? false
        self.allowsPictureInPictureMediaPlayback = UserDefaults.standard.object(forKey: "allowsPictureInPictureMediaPlayback") as? Bool ?? true
        self.allowsAirPlayForMediaPlayback = UserDefaults.standard.object(forKey: "allowsAirPlayForMediaPlayback") as? Bool ?? true
        
        // Content & Rendering Settings
        self.suppressesIncrementalRendering = UserDefaults.standard.object(forKey: "suppressesIncrementalRendering") as? Bool ?? false
        self.ignoresViewportScaleLimits = UserDefaults.standard.object(forKey: "ignoresViewportScaleLimits") as? Bool ?? false
        self.dataDetectorTypes = UserDefaults.standard.object(forKey: "dataDetectorTypes") as? UInt ?? WKDataDetectorTypes.all.rawValue
        
        // Security & Privacy Settings
        self.limitsNavigationsToAppBoundDomains = UserDefaults.standard.object(forKey: "limitsNavigationsToAppBoundDomains") as? Bool ?? false
        self.upgradeKnownHostsToHTTPS = UserDefaults.standard.object(forKey: "upgradeKnownHostsToHTTPS") as? Bool ?? false
        self.isFraudulentWebsiteWarningEnabled = UserDefaults.standard.object(forKey: "isFraudulentWebsiteWarningEnabled") as? Bool ?? true
        
        // Interaction Settings
        self.allowsLinkPreview = UserDefaults.standard.object(forKey: "allowsLinkPreview") as? Bool ?? true
        self.allowsBackForwardNavigationGestures = UserDefaults.standard.object(forKey: "allowsBackForwardNavigationGestures") as? Bool ?? true
        
        // Text & Typography Settings
        self.minimumFontSize = UserDefaults.standard.object(forKey: "minimumFontSize") as? Double ?? 0
        self.isTextInteractionEnabled = UserDefaults.standard.object(forKey: "isTextInteractionEnabled") as? Bool ?? true
        
        // Advanced Settings
        self.shouldPrintBackgrounds = UserDefaults.standard.object(forKey: "shouldPrintBackgrounds") as? Bool ?? false
        self.isElementFullscreenEnabled = UserDefaults.standard.object(forKey: "isElementFullscreenEnabled") as? Bool ?? true
        self.isSiteSpecificQuirksModeEnabled = UserDefaults.standard.object(forKey: "isSiteSpecificQuirksModeEnabled") as? Bool ?? true
        self.customUserAgent = UserDefaults.standard.object(forKey: "customUserAgent") as? String ?? ""
        self.applicationNameForUserAgent = UserDefaults.standard.object(forKey: "applicationNameForUserAgent") as? String ?? ""
        self.preferredContentMode = UserDefaults.standard.object(forKey: "preferredContentMode") as? Int ?? 0 // .recommended
    }
}


