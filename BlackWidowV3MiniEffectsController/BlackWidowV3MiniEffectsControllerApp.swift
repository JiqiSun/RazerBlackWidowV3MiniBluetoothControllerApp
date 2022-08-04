//
//  BlackWidowV3MiniEffectsControllerApp.swift
//  BlackWidowV3MiniEffectsController
//
//  Created by Stan on 04/08/2022.
//

import Cocoa
import SwiftUI

@main
struct BlackWidowV3MiniEffectsControllerApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
        
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {

    private var bluetoothModel: BluetoothModel!
    
    var statusItem: NSStatusItem!

    override init() {
        bluetoothModel = BluetoothModel()

    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
              if let button = statusItem.button {
                  button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "BW Mini effects Bluetooth Controller")
              }
        
        setupMenus()
    }

    func setupMenus() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

}
