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
    
    init() {
        self.isFullscreen = UserDefaults.standard.object(forKey: "isFullscreen") as? Bool ?? false
        self.urlString = UserDefaults.standard.object(forKey: "urlString") as? String ?? "local://index.html"
    }
}


