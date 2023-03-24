//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    // so you can search eassily
    @StateObject var document = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "default")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
                .environmentObject(paletteStore)
        }
    }
}
