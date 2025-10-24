//
//  GoBobbasApp.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import AppsFlyerLib
import FirebaseCore

extension AppDelegate: AppsFlyerLibDelegate {

    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print(installData)
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                // Business logic for Non-organic install scenario is invoked
                if let sourceID = installData["media_source"],
                let campaign = installData["campaign"] {
                    print("This is a Non-organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            }
            else {
                // Business logic for organic install scenario is invoked
            }
        }
    }

    func onConversionDataFail(_ error: any Error) {
        print("onConversionDataFail")
        print(error)
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure AppsFlyer
        AppsFlyerLib.shared().appsFlyerDevKey = "9mbALiWmN3xhVWp3uEqnom"
        AppsFlyerLib.shared().appleAppID = "6751884338"
        /* Uncomment the following line to see AppsFlyer debug logs */
        // AppsFlyerLib.shared().isDebug = true
        // SceneDelegate support
        print("didFinishLaunchingWithOptions")
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        return true
    }
    // SceneDelegate support
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start { result, eror in
            print("Appsflyer started")
            print(result)
            print(eror)
        }
    }
}

@main
struct GoBobbasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataLoadingService = DataLoadingService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataLoadingService)
        }
    }
}
