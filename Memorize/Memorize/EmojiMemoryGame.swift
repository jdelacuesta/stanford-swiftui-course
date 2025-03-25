//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JC Dela Cuesta on 3/14/25.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["🚗", "🚚", "🚀", "🚁", "🚲", "🛴", "🚂", "🚤", "🛶", "🚜"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 10) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intents

    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}

