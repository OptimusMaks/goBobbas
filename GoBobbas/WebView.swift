//
//  WebView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
        }
    }
}

struct FullScreenWebView: View {
    let url: String
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var showExitButton = false
    
    var body: some View {
        ZStack {
            // WebView
            WebView(url: url, canGoBack: $canGoBack, canGoForward: $canGoForward)
                .ignoresSafeArea()
            
            // Exit button (hidden by default, can be shown with gesture)
            VStack {
                HStack {
                    Spacer()
                    if showExitButton {
                        Button(action: {
                            // This WebView is full screen and cannot be exited
                            // as per requirements
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
        }
        .onTapGesture(count: 3) {
            // Triple tap to show/hide exit button (for debugging)
            showExitButton.toggle()
        }
    }
}

#Preview {
    FullScreenWebView(url: "https://google.com")
}
