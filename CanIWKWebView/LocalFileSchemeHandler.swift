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
            print("LocalFileSchemeHandler: No URL in request")
            urlSchemeTask.didFailWithError(URLError(.badURL))
            return
        }
        
        print("LocalFileSchemeHandler: Attempting to load URL: \(url)")
        
        guard let fileUrl = resolveLocalFileURL(from: url) else {
            print("LocalFileSchemeHandler: Could not resolve file URL for: \(url)")
            print("LocalFileSchemeHandler: Bundle path: \(Bundle.main.bundlePath)")
            print("LocalFileSchemeHandler: Resource path: \(Bundle.main.resourcePath ?? "nil")")
            urlSchemeTask.didFailWithError(URLError(.fileDoesNotExist))
            return
        }
        
        guard let data = try? Data(contentsOf: fileUrl) else {
            print("LocalFileSchemeHandler: Could not read data from: \(fileUrl)")
            urlSchemeTask.didFailWithError(URLError(.cannotOpenFile))
            return
        }
        
        let mimeType = resolveMIMEType(for: fileUrl)
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": mimeType]
        )!
        
        print("LocalFileSchemeHandler: Successfully loaded \(data.count) bytes with MIME type: \(mimeType)")
        
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
        guard let fileName = url.host else { return nil }
        
        // Try to find the resource in the main bundle
        if let bundleURL = Bundle.main.url(forResource: fileName, withExtension: nil) {
            return bundleURL
        }
        
        // If not found in bundle, try the path component directly
        let pathComponent = url.path.isEmpty ? fileName : url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if let bundleURL = Bundle.main.url(forResource: pathComponent, withExtension: nil) {
            return bundleURL
        }
        
        // Try without extension parsing
        let fileNameWithoutExt = (fileName as NSString).deletingPathExtension
        let ext = (fileName as NSString).pathExtension
        if !ext.isEmpty, let bundleURL = Bundle.main.url(forResource: fileNameWithoutExt, withExtension: ext) {
            return bundleURL
        }
        
        return nil
    }
    
    private func resolveMIMEType(for url: URL) -> String {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return "application/octet-stream"
        }
        return type.preferredMIMEType ?? "text/html"
    }
}
