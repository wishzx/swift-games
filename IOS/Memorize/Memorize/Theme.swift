//
//  File.swift
//  Memorize
//
//  Created by user225661 on 7/19/22.
//

import Foundation

var theme_counter = 0

struct Theme: Codable, Identifiable, Hashable {
    var name : String
    var emojis : Set<String>
    var pairs : Int
    var cardColor : RGBAColor
    let id : Int
        
    init(name: String, emojis : Set<String>, pairs : Int?, RGBAColor : RGBAColor){
        self.name = name
        self.emojis = emojis
        self.pairs = min(emojis.count,pairs ?? emojis.count)
        self.cardColor = RGBAColor
        self.id = theme_counter
        theme_counter+=1
    }
    
    func getShuffledEmojis() -> [String] {
        return Array(Array(self.emojis).shuffled()[0..<self.pairs])
        }
 
}



struct RGBAColor: Codable, Equatable, Hashable {
    var red: Double = 255
    var green: Double = 0
    var blue: Double = 0
    var alpha: Double = 1
}
