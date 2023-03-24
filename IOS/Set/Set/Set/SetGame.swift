//
//  SetGameModel.swift
//  Set
//
//  Created by user225661 on 7/21/22.
//

import Foundation



struct SetGame {

    private(set) var deck : [Card]
    private var dealtCards = Options.startingCards
    
    init(){
        //create deck
        deck = SetGame.cardContent.shuffled().enumerated().map{
            Card(id:$0,content:$1)
        }
        //deal initial cards
        for i in 0..<Options.startingCards{ deck[i].isPlayed = true}
    }
    
    mutating func match(_ x : Int,_ y : Int,_ z : Int) -> Bool {
        guard x < Options.numberOfCards && y < Options.numberOfCards && z < Options.numberOfCards else{
            return false //should never happens ( maybe throw error insted? )
        }
        var matched = true
        for property in 0..<4 {
            //if first 2 are equal, check if third is not equal
            if deck[x][property] == deck[y][property] {
                if deck[y][property] != deck[z][property]{
                    matched = false ; break
                }
            // else  they are not equual so check if third is equal
            } else {
                if deck[y][property] == deck[z][property] || deck[x][property] == deck[z][property]{
                    matched = false ; break
                }
            }
        }
        if matched {
            deck[x].isMatched = true ; deck[y].isMatched = true ; deck[z].isMatched = true
            draw()
        }
        return matched
    }
    
    var emptyDeck : Bool { Options.numberOfCards == self.dealtCards}
    
    
    mutating func draw(){
        if !emptyDeck {
            for i in dealtCards..<dealtCards+3{
                deck[i].isPlayed = true
            }
            dealtCards+=3
        }
    }
    
    struct Card : Identifiable{
        var id : Int
        var isSelected = false
        var isMatched = false
        var isPlayed = false
        let content : Content
        
        struct Content {
            let symbol : Tris
            let color : Tris
            let number : Tris
            let shade : Tris
            
        }
        subscript(x:Int) -> Tris? {
                get {
                    switch x {
                    case 0 :
                        return content.symbol
                    case 1:
                        return content.color
                    case 2 :
                        return content.number
                    case 3 :
                        return content.shade
                    default:
                        return nil
                    }
                }
            }
    }
    //create all combination of cards
    static let cardContent : [Card.Content] = {
        var cardContents : [Card.Content] = []
        for symbol in Tris.allCases {
            for color in Tris.allCases {
                for number in Tris.allCases{
                    for shade in Tris.allCases{
                        cardContents.append(Card.Content(symbol:symbol,color:color,number:number,shade:shade))
                    }}}}
        assert(cardContents.count == Options.numberOfCards)
        return cardContents
    }()
    
    
    struct Options {
        static let numberOfCards = 81
        static let startingCards = 12
    }
    
}

// a boolean but with 3 states
enum Tris: Int,CaseIterable {
    case one = 0
    case two = 1
    case three = 2

}

//changes the way this struct is printed
extension SetGame.Card: CustomStringConvertible {
    
    var description: String {
        if isPlayed{
            return "Card\(id) : \(content.symbol) \(content.shade) \(content.number) \(content.color) --- matched \(isMatched) \(isSelected)\n"
        }
        else {return ""}
        }
}
