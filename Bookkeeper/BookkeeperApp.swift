//
//  BookkeeperApp.swift
//  Bookkeeper
//
//  Created by Koso Suzuki on 1/7/23.
//

import SwiftUI

@main
struct BookkeeperApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
