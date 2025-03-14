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
    var isFaceUp = false
    var isSelected = false // ✅ Track if card is selected
}

// MARK: - ContentView
struct ContentView: View {
    let vehicleEmojis = ["🚗", "🚚", "🚀", "🚁", "🚲", "🛴", "🚂", "🚤", "🛶", "🚜"]
    let animalEmojis = ["🐶", "🐱", "🐭", "🐰", "🦊", "🐻", "🐼", "🐯", "🦁", "🐮"]
    let foodEmojis = ["🍎", "🍌", "🍉", "🍇", "🍒", "🍓", "🥝", "🥥", "🍍", "🥑"]
    
    @State var cards: [Card] = []
    @State private var emojis: [String] = []
    
    var body: some View {
            title
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(emojis.indices, id: \.self) { index in
                        CardView(card: emojis[index])
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                            }
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                themeButton("Vehicles", emojis: vehicleEmojis, systemImage: "car.fill", pairCount: min(vehicleEmojis.count, 10))
                themeButton("Animals", emojis: animalEmojis, systemImage: "pawprint.fill", pairCount: min(animalEmojis.count, 10))
                themeButton("Food", emojis: foodEmojis, systemImage: "fork.knife", pairCount: min(foodEmojis.count, 10))
            }
            .padding(.top, 10)
    }
    
    // MARK: - Title
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .padding()
    }
    
    // MARK: - Theme Buttons
    func themeButton(_ title: String, emojis: [String], systemImage: String, pairCount: Int) -> some View {
        Button(action: {
            setTheme(with: emojis, pairCount: pairCount)
        }) {
            VStack {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text(title)
                    .font(.caption) // ✅ Smaller font for button text
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 100, height: 100)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Theme Setter
    // MARK: - Theme Setter
    func setTheme(with newEmojis: [String], pairCount: Int) {
        emojis = newEmojis.shuffled()
        cards = emojis
            .prefix(pairCount)
            .enumerated()
            .map { index, emoji in
                Card(
                    id: UUID(),
                    content: emoji,
                    isFaceUp: false // ✅ Cards start face down
                )
            }
        cardCount = min(pairCount, 5) // ✅ Start with 5 cards by default
    }
    
    // MARK: - Flip Card Logic
    func flipCard(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            withAnimation {
                cards[index].isFaceUp.toggle()
                cards[index].isSelected.toggle()
            }
        }
    }
}

// MARK: - CardView
struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            
            if card.isFaceUp {
                base
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1) // ✅ Subtle gray border
                    )
                Text(card.content)
                    .font(.largeTitle)
                    .opacity(1)
            } else {
                base
                    .fill(Color.orange.opacity(card.isSelected ? 0.5 : 1)) // ✅ Orange when selected
                Text(card.content)
                    .opacity(0) // ✅ Hide emoji when face down
            }
        }
        .animation(.spring(), value: card.isSelected)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

