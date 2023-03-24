//
//  MemorizeApp.swift
//  Memorize
//
//  Created by user225661 on 7/18/22.
//

import SwiftUI


@main
struct MemorizeApp: App {
    
     @StateObject var store = ThemeStore(storeName: "default")

    var body: some Scene {
        WindowGroup {
            ThemeSelectView(store: store)
        }
    }
}
