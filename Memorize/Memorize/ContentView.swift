//
//  ContentView.swift
//  Memorize
//
//  Created by JC Dela Cuesta on 3/12/25.
//

import SwiftUI

// MARK: - Card Model
struct Card: Identifiable {
    var id = UUID()
    var content: String
    var isFaceUp = true
}

// MARK: - ContentView
struct ContentView: View {
    // Example themes
    let vehicleEmojis = ["🚗", "🚚", "🚀", "🚁", "🚲", "🛴", "🚂", "🚤", "🛶", "🚜"]
    let animalEmojis = ["🐶", "🐱", "🐭", "🐰", "🦊", "🐻", "🐼", "🐯", "🦁", "🐮"]
    let foodEmojis = ["🍎", "🍌", "🍉", "🍇", "🍒", "🍓", "🥝", "🥥", "🍍", "🥑"]
    
    @State var cards: [Card] = []
    @State var cardCount: Int = 4
    
    var body: some View {
        VStack {
            ScrollView {
                title
                cardsGrid
            }
            Spacer()
            cardCountAdjusters
            themeButtons
        }
        .onAppear {
            setTheme(with: vehicleEmojis, pairCount: min(vehicleEmojis.count, 4))
        }
        .padding()
    }
    
    // MARK: - Title
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .padding()
    }
    
    // MARK: - Cards Grid
    var cardsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        if let index = cards.firstIndex(where: { $0.id == card.id }) {
                            cards[index].isFaceUp.toggle()
                        }
                    }
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
    // MARK: - Card Count Adjusters
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
        .padding()
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            let newCount = cardCount + offset
            if newCount > 0 && newCount <= cards.count {
                cardCount = newCount
            }
        }, label: {
            Image(systemName: symbol)
                .font(.title) // Adjust size here if needed
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > cards.count)
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "rectangle.stack.badge.plus.fill")
    }
    
    // MARK: - Theme Buttons
    var themeButtons: some View {
        HStack {
            Button(action: {
                setTheme(with: vehicleEmojis, pairCount: 4) // 4 pairs = 8 cards
            }) {
                VStack {
                    Image(systemName: "car.fill")
                    Text("Vehicles")
                        .font(.caption)
                }
            }
            Spacer()
            Button(action: {
                setTheme(with: animalEmojis, pairCount: 6) // 6 pairs = 12 cards
            }) {
                VStack {
                    Image(systemName: "pawprint.fill")
                    Text("Animals")
                        .font(.caption)
                }
            }
            Spacer()
            Button(action: {
                setTheme(with: foodEmojis, pairCount: 8) // 8 pairs = 16 cards
            }) {
                VStack {
                    Image(systemName: "applelogo")
                    Text("Food")
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal, 40)
        .font(.title2)
        .foregroundColor(.blue)
    }
    
    // MARK: - Theme Setter
    func setTheme(with emojis: [String], pairCount: Int) {
        let pairs = min(pairCount, emojis.count) // Ensure not to exceed available emojis
        let selectedEmojis = emojis.shuffled().prefix(pairs)
        
        // Create pairs and shuffle them
        cards = (selectedEmojis + selectedEmojis).shuffled().enumerated().map { index, emoji in
            Card(
                id: cards.indices.contains(index) ? cards[index].id : UUID(),
                content: emoji,
                isFaceUp: cards.indices.contains(index) ? cards[index].isFaceUp : true
            )
        }
        
        cardCount = pairs * 2
    }
    
    // MARK: - CardView
    struct CardView: View {
        let card: Card
        
        var body: some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text(card.content).font(.largeTitle)
                }
                .opacity(card.isFaceUp ? 1 : 0)
                base.fill()
                    .opacity(card.isFaceUp ? 0 : 1)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    ContentView()
}
