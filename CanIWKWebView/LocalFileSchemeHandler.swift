//
//  LocalFileSchemeHandler.swift
//  CanIWKWebView
//
//  Created by Niklas Merz on 05.02.25.
//


import WebKit
import UniformTypeIdentifiers

class LocalFileSchemeHandler: NSObject, WKURLSchemeHandler {
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else {
            print("[LocalFileSchemeHandler] No URL in request")
            urlSchemeTask.didFailWithError(URLError(.badURL))
            return
        }
        
        print("[LocalFileSchemeHandler] Loading: \(url.absoluteString)")
        
        guard let fileUrl = resolveLocalFileURL(from: url) else {
            print("[LocalFileSchemeHandler] Could not resolve file URL for: \(url.absoluteString)")
            urlSchemeTask.didFailWithError(URLError(.fileDoesNotExist))
            return
        }
        
        print("[LocalFileSchemeHandler] Resolved to: \(fileUrl.path)")
        
        guard let data = try? Data(contentsOf: fileUrl) else {
            print("[LocalFileSchemeHandler] Could not load data from: \(fileUrl.path)")
            urlSchemeTask.didFailWithError(URLError(.fileDoesNotExist))
            return
        }
        
        let mimeType = resolveMIMEType(for: fileUrl)
        print("[LocalFileSchemeHandler] MIME type: \(mimeType)")
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": mimeType]
        )!
        
        DispatchQueue.main.async {
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        }
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        // Cleanup if needed
    }
    
    private func resolveLocalFileURL(from url: URL) -> URL? {
        // Combine host and path to get the full filename
        // For local://index.html -> host: "index.html", path: ""
        // For local://index.html/styles.css -> host: "index.html", path: "/styles.css"
        // For local://styles.css -> host: "styles.css", path: ""
        
        var fileName: String
        
        // If we have a path component, use just the last path component (the actual filename)
        if !url.path.isEmpty, url.path != "/" {
            fileName = (url.path as NSString).lastPathComponent
        } else if let host = url.host, !host.isEmpty {
            fileName = host
        } else {
            print("[LocalFileSchemeHandler] No host or path in URL: \(url.absoluteString)")
            return nil
        }
        
        print("[LocalFileSchemeHandler] Looking for file: \(fileName)")
        
        // Split filename and extension
        let fileNameString = fileName as NSString
        let ext = fileNameString.pathExtension
        let name = ext.isEmpty ? fileName : fileNameString.deletingPathExtension
        
        print("[LocalFileSchemeHandler] Resource name: '\(name)', extension: '\(ext.isEmpty ? "nil" : ext)'")
        
        let bundleURL = Bundle.main.url(forResource: name, withExtension: ext.isEmpty ? nil : ext)
        
        if bundleURL == nil {
            print("[LocalFileSchemeHandler] Not found in bundle: \(name).\(ext)")
        }
        
        return bundleURL
    }
    
    private func resolveMIMEType(for url: URL) -> String {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return "application/octet-stream"
        }
        return type.preferredMIMEType ?? "text/html"
    }
}
