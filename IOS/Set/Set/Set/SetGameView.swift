//
//  ContentView.swift
//  Set
//
//  Created by user225661 on 7/21/22.
//

import SwiftUI

struct SetGameView: View {
    @Namespace private var dealingCards

    @ObservedObject var game = MySetGame()
    
    
    var body: some View {
        VStack{
            board
            HStack{discarded; Spacer(); newGame; Spacer(); deck}.padding()
        }.onAppear(){
            // deal initial cards from deck
            
            withAnimation{
                for card in game.board {
                    withAnimation(dealAnimation(for: card.id)){
                        deal(card)
                    }
                }
            }
        }
        
    }
    
    @State private var dealtIDs = Set<Int>()
    @State private var discardedIds = Set<Int>()

    // marks the given card as having been dealt
    private func deal(_ card: SetGame.Card) {
        dealtIDs.insert(card.id)
    }
    
    // returns whether the given card has not been dealt yet
    private func isUndealt(_ card: SetGame.Card) -> Bool {
        !dealtIDs.contains(card.id)
    }
    
        
    var deck : some View {
        ZStack{
            ForEach(game.deck){card in
                if isUndealt(card){
                    Card(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingCards)
                    .zIndex(zIndex(of: card))
                    .offset(offsetDeck(card.id))
                }
            }
            ForEach(game.board){card in
                if isUndealt(card){
                    Card(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingCards)
                    .zIndex(zIndex(of: card))
                    .offset(CGSize(width: 20, height: -40))
            }
            
            }
        }
        .frame(width: C.deckSize*C.aspectRatio, height: C.deckSize)
        .onTapGesture{
            withAnimation(){
                game.drawCards()
                for card in game.board{
                    deal(card)
                }
            }
        }
    }
    
    
    var discarded : some View {
        deckify(game.discarded)
    }
    
    private func offsetDeck(_ cardId : Int) -> CGSize {
        return CGSize(width: 0, height: Double(cardId)*0.1)
    }
    private func offsetDiscarded(_ cardId : Int) -> CGSize {
        return CGSize(width: Double(cardId)*1, height: Double(cardId)*1)
    }
    
    @ViewBuilder private func deckify(_ cards : [SetGame.Card]) -> some View {
        ZStack{
            ForEach(cards){card in
                if discardedIds.contains(card.id){
                    Card(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingCards)
                    .offset(offsetDeck(card.id))

                }else {
                    Color.clear
                }
                
                
            }

        }
        .frame(width: C.deckSize*C.aspectRatio, height: C.deckSize)
    }
    
    
    
    var board : some View {
        AspectVGrid(items: game.board, aspectRatio: C.aspectRatio){ card in
            if (isUndealt(card)){Color.clear}
            else {
                let color = highlightedColor(ofCard: card)
                Card(card: card)
                    .border(card.isMatched ? .green : color , width: 5)
                    .matchedGeometryEffect(id: card.id, in: dealingCards)
                    .onTapGesture {
                        withAnimation(){
                            if !card.isMatched {
                                let wasLastTrioMatched = game.choose(card.id)
                                // deal new cards if was matched
                                if let wasLastTrioMatched = wasLastTrioMatched {
                                    if wasLastTrioMatched == true {
                                        // animate the match
                                        withAnimation(Animation.linear(duration: 1).delay(1)){
                                            // animate card deal
                                            for card in game.board{
                                                deal(card)
                                            }
                                        }
                                        
                                            for card in game.discarded{
                                                discardedIds.insert(card.id)
                                            }
                                        // animate discard card
                                    }
                                    else {
                                        // animate the mismatch
                                    }
                                }
                            }
                        }
                    }
                    
            }
        }

    }
    
    // an Animation used to deal the cards out "not all at the same time"
    // the Animation is delayed depending on the index of the given card
    //  in our ViewModel's (and thus our Model's) cards array
    // the further the card is into that array, the more the animation is delayed
    private func dealAnimation(for cardId: Int) -> Animation {
        return Animation.easeInOut(duration: 2).delay(Double(cardId) * (Double(2) / Double(12)))
    }
    
    // returns a Double which is a bigger number the closer a card is to the front of the cards array
    // used by both of our matchedGeometryEffect CardViews
    //  so that they order the cards in the "z" direction in the same way
    // (the "z" direction is the direction going up out of the device towards the user)
    private func zIndex(of card: SetGame.Card) -> Double {
            -Double(card.id)
    }
    
    
    var newGame : some View {
        Button("New Game"){
            dealtIDs = []
            discardedIds = []
            game.newGame()
            withAnimation(){
            for card in game.board {
                deal(card)
            }
            }
        }
    }
    
    func highlightedColor(ofCard card : SetGame.Card)->Color{
        if game.selectedCards.contains(card.id) {
            if game.wasLastTrioMatched != nil{return card.isMatched ? C.correctColor : C.wrongColor}
            return C.selectedColor
        }
        return C.unselectedColor
    }
    
    struct C {
        static let aspectRatio : CGFloat = 2/3
        static let deckSize : CGFloat = 75
        static let selectedColor : Color = .black
        static let correctColor : Color = .green
        static let wrongColor : Color = .red
        static let unselectedColor : Color = .clear
    }
        
}







struct Card: View {
    var card : SetGame.Card
    
    var body : some View {
            createCardContent()
            .cardify(isFaceUp: card.isPlayed)
                .padding(C.paddingAroundCard)
                .foregroundColor(C.backColor)
    }
    
    @ViewBuilder private func createCardContent() -> some View{
        GeometryReader{ geometry in
            VStack{
                Group{
                    let insideShape = drawShape()
                        .frame(height: geometry.size.height * C.individualShapeHeight)
                    
                    switch card.content.number {
                    case Tris.one:
                        Spacer(); insideShape; Spacer()
                    case Tris.two:
                        Spacer(); insideShape; Spacer(); insideShape; Spacer()
                    case Tris.three:
                        Spacer(); insideShape; Spacer(); insideShape; Spacer(); insideShape; Spacer();
                    }
                }
                .padding(.horizontal,C.horizontalPadding)
                .foregroundColor(C.colors[card.content.color.rawValue])

            }
        }
    }

    @ViewBuilder private func drawShape()-> some View{
        switch card.content.symbol {
            case Tris.one: drawStroke(inside: Rectangle())
            case Tris.two: drawStroke(inside: Diamond())
            case Tris.three: drawStroke(inside: Ellipse())
        }
    }
    
    @ViewBuilder private func drawStroke<S: Shape>(inside shape : S) -> some View {
        switch card.content.shade{
            case Tris.one: shape.opacity(0.1)
            case Tris.two: shape.stroke()
            case Tris.three: shape}
    }
    
    private struct C {
        static let colors = [Color.blue, .green, .red]
        static let individualShapeHeight : CGFloat = 0.1
        static let horizontalPadding : CGFloat = 5
        static let paddingAroundCard : CGFloat = 4
        static let backColor : Color = .gray
    }
}















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
