//
//  Browser_LoaderApp.swift
//  Browser Loader
//
//  Created by Slavik Nychkalo on 05.04.2023.
//

import Foundation
import SwiftUI
import Cocoa


class AppDelegate: NSResponder, NSApplicationDelegate {
    func openUrl(bundleId: String, urls: [URL]) {
        let browserURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId)!
        
        NSWorkspace.shared.open(urls, withApplicationAt: browserURL, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        let browsers = [
            "com.apple.Safari",
            "com.google.Chrome",
            "org.mozilla.firefox"
        ]
        let defaultBrowser = browsers[0]
        for browser in browsers {
            if NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == browser }) {
                self.openUrl(bundleId: browser, urls: urls)
                return
            }
        }
        self.openUrl(bundleId: defaultBrowser, urls: urls)
    }
}


@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

