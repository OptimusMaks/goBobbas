//
//  ContentView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import AppsFlyerLib

struct ContentView: View {
    @EnvironmentObject var dataLoadingService: DataLoadingService
    
    var body: some View {
        ZStack {
            if dataLoadingService.isLoading {
                LoadingView()
            } else if dataLoadingService.shouldShowWebView && !dataLoadingService.finalUrl.isEmpty {
                FullScreenWebView(url: dataLoadingService.finalUrl)
            } else {
                MainMenuView()
            }
        }
        .onAppear {
            // Start AppsFlyer when the app becomes active
            AppsFlyerLib.shared().start()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataLoadingService())
}
