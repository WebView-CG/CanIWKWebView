//
//  AppSettings.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 15.02.25.
//

import Foundation

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
    
    // JavaScript Settings
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
    
    // Media Settings
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
    
    // Content Settings
    @Published var allowsAirPlayForMediaPlayback: Bool {
        didSet {
            UserDefaults.standard.set(allowsAirPlayForMediaPlayback, forKey: "allowsAirPlayForMediaPlayback")
        }
    }
    
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
    
    // Interaction Settings
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
        
        // Content Settings
        self.allowsAirPlayForMediaPlayback = UserDefaults.standard.object(forKey: "allowsAirPlayForMediaPlayback") as? Bool ?? true
        self.suppressesIncrementalRendering = UserDefaults.standard.object(forKey: "suppressesIncrementalRendering") as? Bool ?? false
        self.ignoresViewportScaleLimits = UserDefaults.standard.object(forKey: "ignoresViewportScaleLimits") as? Bool ?? false
        
        // Interaction Settings
        self.allowsLinkPreview = UserDefaults.standard.object(forKey: "allowsLinkPreview") as? Bool ?? true
        self.allowsBackForwardNavigationGestures = UserDefaults.standard.object(forKey: "allowsBackForwardNavigationGestures") as? Bool ?? true
    }
}


