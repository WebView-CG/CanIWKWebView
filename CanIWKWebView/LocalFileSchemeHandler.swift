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
        guard let url = urlSchemeTask.request.url,
              let fileUrl = resolveLocalFileURL(from: url),
              let data = try? Data(contentsOf: fileUrl) else {
            urlSchemeTask.didFailWithError(URLError(.fileDoesNotExist))
            return
        }
        
        let mimeType = resolveMIMEType(for: fileUrl)
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
        guard let fileName = url.host else { return nil }
        return Bundle.main.url(forResource: fileName, withExtension: nil)
    }
    
    private func resolveMIMEType(for url: URL) -> String {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return "application/octet-stream"
        }
        return type.preferredMIMEType ?? "text/html"
    }
}
