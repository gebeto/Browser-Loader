//
//  Browser_LoaderApp.swift
//  Browser Loader
//
//  Created by Slavik Nychkalo on 05.04.2023.
//

import Foundation
import SwiftUI
import Cocoa


struct PopoverView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8, content: {
            Text("Browser Loader")
            
            HStack(alignment: .top, spacing: 0) {
                Button("Exit") {
                    exit(0)
                }
            }
        }).padding()
    }
}


class AppDelegate: NSResponder, NSApplicationDelegate {
    private var popover: NSPopover!
    private var statusItem: NSStatusItem!
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusButtons = statusItem.button {
            statusButtons.image = NSImage(named: NSImage.Name("StatusBarIcon"))
            statusButtons.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 200, height: 100)
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: PopoverView())
    }
    
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

