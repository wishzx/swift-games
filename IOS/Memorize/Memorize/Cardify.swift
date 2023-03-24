//
//  Cardify.swift
//  Memorize
//
//  Created by user225661 on 7/25/22.
//

import SwiftUI
// like view mondifier but is animatable
struct Cardify : AnimatableModifier{
    
    init(isFaceUp: Bool, color : Color){
        rotation = isFaceUp ? 0 : 180
        self.color = color
    }
    var color : Color
    
    var rotation : Double
    
    
    var animatableData: Double {
        get { return rotation}
        set { rotation = newValue}
    }
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                

            }else {
                shape.fill().foregroundColor(color)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis : (0,1,0))
    }
        
        
    private struct DrawingConstants{
            static let cornerRadius : CGFloat = 15
            static let lineWidth : CGFloat = 4
        }
}

extension View {
    func cardify(isFaceUp : Bool, color : Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}
