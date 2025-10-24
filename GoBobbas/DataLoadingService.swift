//
//  DataLoadingService.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import AppsFlyerLib
import FirebaseRemoteConfig
import FirebaseCore

class DataLoadingService: NSObject, ObservableObject {
    @Published var isLoading = true
    @Published var conversionData: [AnyHashable: Any] = [:]
    @Published var privacyUrl: String = ""
    @Published var isDataLoaded = false
    @Published var shouldShowWebView = false
    @Published var finalUrl: String = ""
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let userDefaults = UserDefaults.standard
    private let conversionDataKey = "ConversionData"
    private let privacyUrlKey = "PrivacyUrl"
    private let finalUrlKey = "FinalUrl"
    
    override init() {
        super.init()
        setupRemoteConfig()
        loadCachedData()
    }
    
    private func setupRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // For development
        remoteConfig.configSettings = settings
        
        // Set default values
        remoteConfig.setDefaults([
            "privacyUrl": "" as NSObject
        ])
    }
    
    private func loadCachedData() {
        // Check if we have cached data
        if let cachedConversionData = userDefaults.object(forKey: conversionDataKey) as? [String: Any] {
            self.conversionData = cachedConversionData
            self.isDataLoaded = true
        }
        
        if let cachedPrivacyUrl = userDefaults.string(forKey: privacyUrlKey), !cachedPrivacyUrl.isEmpty {
            self.privacyUrl = cachedPrivacyUrl
        }
        
        if let cachedFinalUrl = userDefaults.string(forKey: finalUrlKey), !cachedFinalUrl.isEmpty {
            self.finalUrl = cachedFinalUrl
            self.shouldShowWebView = true
            self.isLoading = false
            return
        }
        
        // If we have both conversion data and privacy URL, we can proceed
        if !conversionData.isEmpty && !privacyUrl.isEmpty {
            generateFinalUrl()
            self.isLoading = false
            return
        }
        
        // Start loading fresh data
        startDataLoading()
    }
    
    private func startDataLoading() {
        // Start AppsFlyer conversion data loading
        AppsFlyerLib.shared().delegate = self
        
        // Start Remote Config fetch
        fetchRemoteConfig()
    }
    
    private func fetchRemoteConfig() {
        remoteConfig.fetch { [weak self] status, error in
            DispatchQueue.main.async {
                if status == .success {
                    self?.remoteConfig.activate { _, _ in
                        self?.privacyUrl = self?.remoteConfig.configValue(forKey: "privacyUrl").stringValue ?? ""
                        self?.userDefaults.set(self?.privacyUrl, forKey: self?.privacyUrlKey ?? "")
                        
                        // Check if we can proceed
                        self?.checkIfDataReady()
                    }
                } else {
                    print("Remote Config fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                    self?.checkIfDataReady()
                }
            }
        }
    }
    
    private func checkIfDataReady() {
        // If we have both conversion data and privacy URL, generate final URL
        if !conversionData.isEmpty && !privacyUrl.isEmpty {
            generateFinalUrl()
            self.isLoading = false
        }
        // If privacy URL is empty, show onboarding
        else if privacyUrl.isEmpty {
            self.isLoading = false
        }
    }
    
    private func generateFinalUrl() {
        guard !privacyUrl.isEmpty else { return }
        
        var urlComponents = URLComponents(string: privacyUrl)
        var queryItems: [URLQueryItem] = []
        
        // Convert conversion data to query parameters
        for (key, value) in conversionData {
            if let keyString = key as? String {
                let valueString = "\(value)"
                queryItems.append(URLQueryItem(name: keyString, value: valueString))
            }
        }
        
        urlComponents?.queryItems = queryItems
        self.finalUrl = urlComponents?.url?.absoluteString ?? privacyUrl
        
        // Cache the final URL
        userDefaults.set(self.finalUrl, forKey: finalUrlKey)
        
        // Show WebView
        self.shouldShowWebView = true
    }
    
    func resetData() {
        userDefaults.removeObject(forKey: conversionDataKey)
        userDefaults.removeObject(forKey: privacyUrlKey)
        userDefaults.removeObject(forKey: finalUrlKey)
        
        conversionData = [:]
        privacyUrl = ""
        finalUrl = ""
        shouldShowWebView = false
        isDataLoaded = false
        isLoading = true
        
        startDataLoading()
    }
}

// MARK: - AppsFlyerLibDelegate
extension DataLoadingService: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            self.conversionData = installData
            
            // Convert to [String: Any] for UserDefaults compatibility
            var stringKeyedData: [String: Any] = [:]
            for (key, value) in installData {
                if let keyString = key as? String {
                    stringKeyedData[keyString] = value
                }
            }
            
            // Cache conversion data
            self.userDefaults.set(stringKeyedData, forKey: self.conversionDataKey)
            
            // Check if we can proceed
            self.checkIfDataReady()
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        DispatchQueue.main.async {
            print("AppsFlyer conversion data failed: \(error.localizedDescription)")
            self.checkIfDataReady()
        }
    }
}
