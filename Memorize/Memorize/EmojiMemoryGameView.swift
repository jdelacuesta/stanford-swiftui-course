//
//  ContentView.swift
//  Memorize
//
//  Created by JC Dela Cuesta on 3/12/25.
//

import SwiftUI

struct Theme {
    var name: String
    var emojis: [String]
    var numberOfPairs: Int
    var color: Color
}

// MARK: - Defining the MemoryGameModel with Themes

class MemoryGameViewModel: ObservableObject {
    @Published var cards: [MemoryGame<String>.Card]
    @Published var currentTheme: Theme?
    @Published var score = 0
    
    private let themes: [Theme] = [
        Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻"], numberOfPairs: 3, color: .green),
        Theme(name: "Faces", emojis: ["😀", "😁", "😃", "😄", "😅", "😆"], numberOfPairs: 3, color: .blue),
        Theme(name: "Food", emojis: ["🍏", "🍔", "🍕", "🍦", "🍩", "🍓"], numberOfPairs: 3, color: .orange)
    ]
    
    init(theme: Theme) {
           self.currentTheme = theme
           self.cards = MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
               theme.emojis[pairIndex]
           }.cards
       }

    func choose(_ card: MemoryGame<String>.Card) {
           // Handle game logic here
       }

    func startNewGame(theme: Theme? = nil) {
        if let theme = theme {
            currentTheme = theme
            cards = MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
                theme.emojis[pairIndex]
            }.cards
        }
    }
}
    

//MARK: -

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    
    var body: some View {
        VStack {
            gameGrid
            themeButtons
            newGameButton
        }
    }
    
    // MARK: - Game Grid
    var gameGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(card: viewModel.cards[index], action: {
                    viewModel.choose(viewModel.cards[index])
                })
                .aspectRatio(2/3, contentMode: .fit)
                .padding(4)
            }
        }
        .foregroundColor(viewModel.currentTheme?.color ?? .green)
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Theme Buttons
    var themeButtons: some View {
        HStack {
            themeButton("Vehicles", emojis: ["🚗", "🚚", "🚀", "🚁", "🚲", "🛴"], pairCount: 6)
            themeButton("Animals", emojis: ["🐶", "🐱", "🐭", "🐰", "🦊", "🐻"], pairCount: 6)
            themeButton("Food", emojis: ["🍎", "🍌", "🍉", "🍇", "🍒", "🍓"], pairCount: 6)
        }
        .padding(.top, 10)
    }
    
    // MARK: - Theme Button Helper
    private func themeButton(_ title: String, emojis: [String], pairCount: Int) -> some View {
        Button(action: {
            let theme = Theme(name: title, emojis: emojis, numberOfPairs: pairCount, color: .green)
            viewModel.startNewGame(theme: theme)
        }) {
            VStack {
                Image(systemName: "car.fill") // Example icon
                Text(title)
            }
        }
        .buttonStyle(.bordered)
        .padding()
    }
    
    // MARK: - New Game Button
    var newGameButton: some View {
        Button("New Game") {
            viewModel.startNewGame()
        }
        .buttonStyle(.bordered)
        .padding()
    }
    
    // MARK: - Card View
    struct CardView: View {
        var card: MemoryGame<String>.Card
        var action: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(card.isFaceUp ? Color.white : Color.blue)
                    .shadow(radius: 5)
                Text(card.content)
                    .font(.largeTitle)
                    .opacity(card.isFaceUp ? 1 : 0)
            }
            .frame(width: 75, height: 100)
            .onTapGesture {
                action()
            }
        }
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiMemoryGameView(viewModel: MemoryGameViewModel(theme: Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻"], numberOfPairs: 3, color: .green)))
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.light)
            
            EmojiMemoryGameView(viewModel: MemoryGameViewModel(theme: Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻"], numberOfPairs: 3, color: .green)))
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
