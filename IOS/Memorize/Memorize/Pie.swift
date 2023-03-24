//
//  Pie.swift
//  Memorize
//
//  Created by user225661 on 7/21/22.
//

import Foundation
import SwiftUI


struct Pie : Shape {
    //need to be far because we want to animate it
    var startAngle : Angle
    var endAngle : Angle
    
    var animatableData: AnimatablePair<Double,Double>{
        get{
            AnimatablePair(startAngle.radians,endAngle.radians)
        }
        set{
            startAngle = Angle(radians: newValue.first)
            endAngle = Angle(radians: newValue.second)
        }
    }
    
    //this var also because we want someone to be able to change it in the init
    var clockwise = false
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width,rect.width) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to : start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to : center)
        
        
        
        return p
    }
    
    
    
}
