//
//  EmojyMemoryGame.swift
//  Memorize
//
//  Created by user225661 on 7/19/22.
//

import SwiftUI

// ObservableObjkect makes so that you get @published / objectWillChange : ObservableObjectPublisher
class EmojiMemoryGame: ObservableObject{
    typealias Card = MemoryGame<String>.Card

    @Published private var model : MemoryGame<String>
    @Published private(set) var theme : Theme {
        didSet{
            
            let emojis = theme.getShuffledEmojis()
            self.model = MemoryGame<String>(numberOfPairsOfCards: theme.pairs){ index in
                return emojis[index]}
        }
    }
    
    
    
    init(theme: Theme){
        self.theme = theme
        let emojis = theme.getShuffledEmojis()
        print(emojis)
        self.model = MemoryGame<String>(numberOfPairsOfCards: theme.pairs){ index in
            return emojis[index]}
    }
    
    var gameScore : Int {
        return model.score
    }
    
    var themePairs : Int {
        return theme.pairs
    }
    
    var themeName : String {
        return theme.name
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // 	: - Intent(s)
    func choose(_ card : MemoryGame<String>.Card){
        //@published make this automatic
        //objectWillChange.send()
        model.choose(card)
    }
    
    func shuffle(){
        model.shuffle()
    }
    
    func newGame(){
        let emojis = theme.getShuffledEmojis()
        print(emojis)
        self.model = MemoryGame<String>(numberOfPairsOfCards: theme.pairs){ index in
            return emojis[index]}
    }
    

}
