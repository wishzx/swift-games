//
//  MySetGame.swift
//  Set
//
//  Created by user225661 on 7/21/22.
//

import Foundation


class MySetGame : ObservableObject {
    typealias Card = SetGame.Card
    
    @Published private(set) var game = SetGame()
    @Published private(set) var wasLastTrioMatched : Bool?
    @Published private(set) var selectedCards = [Int]()
    
    var noMoreCards : Bool {game.emptyDeck}
    
    var board : [Card] { game.deck.filter { $0.isPlayed && !$0.isMatched}}
    var deck : [Card] {game.deck.filter{ !$0.isPlayed}}
    var discarded : [Card] {game.deck.filter{ $0.isMatched}}

    
    //MARK : Intent(s)
    func newGame() {game = SetGame(); selectedCards=[]; wasLastTrioMatched=nil}
    func drawCards(){game.draw()}
    func choose(_ id :Int)-> Bool?{
        //if it was selected then unselect it
        if selectedCards.contains(id) {
            selectedCards.remove(at: selectedCards.firstIndex(of: id)!)
            return nil
        }
        // if we just matched remove all selected cards
        if wasLastTrioMatched != nil{
            wasLastTrioMatched = nil
            selectedCards = []
        }
        // select the clicked card
        selectedCards.append(id)
        if selectedCards.count == 3{
            wasLastTrioMatched = game.match(selectedCards[0], selectedCards[1], selectedCards[2])
        }
        
        return wasLastTrioMatched

    }
}


