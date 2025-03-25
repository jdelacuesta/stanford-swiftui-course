//
//  MemorizeApp.swift
//  Memorize
//
//  Created by JC Dela Cuesta on 3/12/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let theme = Theme(
        name: "Vehicles",
        emojis: ["🚗", "🚚", "🚀", "🚁", "🚲", "🛴", "🚂", "🚤", "🛶", "🚜"],
        numberOfPairs: 10,
        color: .blue // <-- Add the color here
    )

    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: MemoryGameViewModel(theme: theme))
        }
    }
}
