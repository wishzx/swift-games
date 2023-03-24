//
//  MemoryGame.swift
//  Memorize
//
//  Created by user225661 on 7/19/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent : Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get{ cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        set{ cards.indices.forEach{cards[$0].isFaceUp = (newValue == $0)}}
    }
    
    private(set) var score: Int = 0
    private var lastGuess: Date = Date.now
    

    
    init(numberOfPairsOfCards: Int, createCardContent : (Int) -> CardContent ){
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards{
            let content : CardContent = createCardContent(pairIndex)
            cards.append(Card(id:pairIndex*2,content: content))
            cards.append(Card(id:pairIndex*2+1,content: content))

            
        }
        cards.shuffle()
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    // _ because its rendundant to the type
    mutating func choose(_ card : Card){
        
        //check if card exist and card is not facedup "," is like &&
        if let chosenCardIndex = cards.firstIndex(where: {  $0.id == card.id }),
           !cards[chosenCardIndex].isFaceUp,
           !cards[chosenCardIndex].isMatched
        {
            //check if a card is facedup
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                //one card up
                
                //matching
                if cards[chosenCardIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenCardIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    let seconds = Date().timeIntervalSince(self.lastGuess)
                    score+=max(5-Int(seconds),1)*2
                    self.lastGuess = Date.now

                }
                //if not maching check if mismatch
                else{
                    //penalize
                    if cards[chosenCardIndex].isAlreadySeen {
                        score-=1
                    }
                    if cards[potentialMatchIndex].isAlreadySeen {
                        score-=1
                    }
                }
                //mark both cards as alreday seen
                cards[chosenCardIndex].isAlreadySeen = true
                cards[potentialMatchIndex].isAlreadySeen = true

            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenCardIndex
            }
            cards[chosenCardIndex].isFaceUp = true
            
            
        } else {
            print("We couldnt find the index of the card \(card)")
        }

    }
    //inside so that it gains the name MemoryGame.Card
    struct Card :Identifiable{
        let id: Int
        var isFaceUp = false {
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var isAlreadySeen = false
        let content : CardContent
        
        // MARK: - Bonus Time
               
               // this could give matching bonus points
               // if the user matches the card
               // before a certain amount of time passes during which the card is face up
               
               // can be zero which means "no bonus available" for this card
               var bonusTimeLimit: TimeInterval = 6
               
               // how long this card has ever been face up
               private var faceUpTime: TimeInterval {
                   if let lastFaceUpDate = self.lastFaceUpDate {
                       return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
                   } else {
                       return pastFaceUpTime
                   }
               }
               // the last time this card was turned face up (and is still face up)
               var lastFaceUpDate: Date?
               // the accumulated time this card has been face up in the past
               // (i.e. not including the current time it's been face up if it is currently so)
               var pastFaceUpTime: TimeInterval = 0
               
               // how much time left before the bonus opportunity runs out
               var bonusTimeRemaining: TimeInterval {
                   max(0, bonusTimeLimit - faceUpTime)
               }
               // percentage of the bonus time remaining
               var bonusRemaining: Double {
                   (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
               }
               // whether the card was matched during the bonus time period
               var hasEarnedBonus: Bool {
                   isMatched && bonusTimeRemaining > 0
               }
               // whether we are currently face up, unmatched and have not yet used up the bonus window
               var isConsumingBonusTime: Bool {
                   isFaceUp && !isMatched && bonusTimeRemaining > 0
               }
               
               // called when the card transitions to face up state
               private mutating func startUsingBonusTime() {
                   if isConsumingBonusTime, lastFaceUpDate == nil {
                       lastFaceUpDate = Date()
                   }
               }
               // called when the card goes back face down (or gets matched)
               private mutating func stopUsingBonusTime() {
                   pastFaceUpTime = faceUpTime
                   self.lastFaceUpDate = nil
               }
        
    }
    
    

}


extension Array {
    //can only add computed vars
    var oneAndOnly : Element?{
        if self.count == 1{
            return self.first
        }
        else {
            return nil
        }
    }
    
}
