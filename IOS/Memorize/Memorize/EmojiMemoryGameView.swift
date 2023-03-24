//
//  ContentView.swift
//  Memorize
//
//  Created by user225661 on 7/18/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // tell you to look for ObjectWillChange and update when that happens
    // a wrapper wants a var and not a let
    @ObservedObject var game : EmojiMemoryGame
    @EnvironmentObject var store : ThemeStore
    
    @Namespace private var dealingNamespace
    

    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack{
                scoreboard
                gameBody
                controls
                
            }.padding()
        deckBody

        }
       
    }
    
    var gameBody : some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) {card in
            if (isUndealt(card)) || card.isMatched && !card.isFaceUp {
                //Rectangle().opacity(0)
                Color.clear
            }else{
                CardView(card:card,color: game.theme.color)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                .zIndex(zIndex(of: card))
                .onTapGesture{
                    withAnimation(Animation.easeInOut){
                        game.choose(card)

                    }
                }
    
            }
        }
        

    }
    // no duplicate so Int must be hashable
    @State private var dealtCard = Set<Int>()
    
    private func deal(_ card : EmojiMemoryGame.Card) {
        dealtCard.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card)->Bool{
        !dealtCard.contains(card.id)
    }
    private func dealAnimation(for card : EmojiMemoryGame.Card)->Animation{
        var delay = 0.0
        if let index = game.cards.firstIndex(where:{ $0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count) )
        }
            
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    var deckBody : some View {
        ZStack{
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card, color: game.theme.color)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))


            }
        }.frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            .foregroundColor(game.theme.color)
        .onTapGesture {

        //deal card
            for card in game.cards {

                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    private func zIndex(of card : EmojiMemoryGame.Card) -> Double{
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }

    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    var scoreboard : some View {
        VStack{
            Text("Memorize!").font(.largeTitle)
            Text(game.themeName)
            Text("score : \(game.gameScore)")
        }
    }
    var controls : some View {
        HStack{
            shuffle
            Spacer()
            newGame
        }
    }
    var shuffle : some View {
        Button("SHUFFLE"){
            withAnimation(){
                //it animates because inside lazyvgrid there are viewmodfiier like position and frame that change parameters so that's what's being animated
                
                //explicit animation often in intent because something will change
               game.shuffle()

            }
        }
    }
    var newGame : some View {
        Button {
            withAnimation{
                dealtCard = []
                game.newGame()
                
            }
            
        } label : {
            VStack{
                Image(systemName: "gamecontroller")
                Text("New Game")
            }
        }
    }

}



struct CardView: View{
    let card : MemoryGame<String>.Card
    let color : Color
    
    @State private var animatedBonusRemaining : Double = 0
    
    var body: some View{
        GeometryReader(content:{geometry in
            ZStack{
                Group {
                    if card.isConsumingBonusTime{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear{
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaining = 0
                                }
                            }
                    }else{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }.opacity(0.5).padding(4)
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    .animation(Animation.linear(duration:1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                
            }.cardify(isFaceUp: card.isFaceUp, color: color)
        })
            
        
    }
    

    
    private func scale(thatFits size : CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale )
    }
    
    private struct DrawingConstants{
        static let fontScale : CGFloat = 0.70
        static let fontSize : CGFloat = 32

    }

}




















struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemeStore(storeName: "preview").themes[0])
        // you can start the previw with some state and have multiple previews with many states
        
        game.choose(game.cards.first!)
        
        
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portraitUpsideDown)
        //EmojiMemoryGameView(game: game)
        //    .preferredColorScheme(.light)
    }
}
