//
//  MemorizeApp.swift
//  Memorize
//
//  Created by JC Dela Cuesta on 3/12/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
