//
//  Diamond.swift
//  Set
//
//  Created by user225661 on 7/21/22.
//

import Foundation
import SwiftUI

struct Diamond : Shape {
    func path(in rect: CGRect) -> Path {
        
        let topPoint = CGPoint(x: rect.width/2, y: 0)
        let leftPoint = CGPoint(x: 0, y: rect.height/2)
        let bottomPoint = CGPoint(x: rect.width/2, y: rect.height)
        let rightPoint = CGPoint(x: rect.width, y: rect.height/2)
        
        
        var path = Path()
        
        path.move(to: topPoint)
        path.addLine(to: leftPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: topPoint)


        return path
    }
    
    
}


struct Wiggle : Shape {
    func path(in rect: CGRect) -> Path {
        
        let topR = CGPoint(x: rect.width*0.9, y:0)
        let botR = CGPoint(x: rect.width*0.8, y:rect.height*0.9)
        let control = CGPoint(x: rect.width*1.2, y: rect.height*0.7)
        let control2 = CGPoint(x: rect.width*0.2, y:rect.height*0.5)
        let p2 = CGPoint(x: rect.width*0.1, y: rect.height*0.5)
        let p21 = CGPoint(x:rect.width*0.8, y:-rect.height*2)
        let p22 = CGPoint(x:rect.width*0.4, y:rect.height*2)
        var path = Path()
        
        path.move(to: topR)
        path.addQuadCurve(to: botR, control: control)
        //path.addQuadCurve(to: topR, control: control2)
        path.addCurve(to: p2, control1: p21, control2: p22)
        //path.addCurve(to: topR, control1: p21, control2: p22)
        return path
        
    }
}


//https://stackoverflow.com/questions/63130755/custom-cross-hatched-background-shape-or-view-in-swiftui
import SwiftUI
import CoreImage.CIFilterBuiltins

extension CGImage {

    static func generateStripePattern(
        colors: (UIColor, UIColor) = (.clear, .black),
        width: CGFloat = 6,
        ratio: CGFloat = 1) -> CGImage? {

    let context = CIContext()
    let stripes = CIFilter.stripesGenerator()
    stripes.color0 = CIColor(color: colors.0)
    stripes.color1 = CIColor(color: colors.1)
    stripes.width = Float(width)
    stripes.center = CGPoint(x: 1-width*ratio, y: 0)
    let size = CGSize(width: width, height: 1)

    guard
        let stripesImage = stripes.outputImage,
        let image = context.createCGImage(stripesImage, from: CGRect(origin: .zero, size: size))
    else { return nil }
    return image
  }
}

extension Shape {

    func stripes(angle: Double = 45) -> AnyView {
        guard
            let stripePattern = CGImage.generateStripePattern()
        else { return AnyView(self)}

        return AnyView(Rectangle().fill(ImagePaint(
            image: Image(decorative: stripePattern, scale: 1.0)))
        .scaleEffect(2)
        .rotationEffect(.degrees(angle))
        .clipShape(self))
    }
}
