//
//  ThemeManager.swift
//  Memorize
//
//  Created by user225661 on 8/6/22.
//

import SwiftUI

class ThemeStore : ObservableObject {
    
    var storeName : String
    
    @Published var themes = [Theme](){
        didSet{save()}
    }
    
    private var memoryGameThemesKey:  String { "memoryGameThemesKey-\(storeName)" }
    
    private func save(){
        let data = try? JSONEncoder().encode(themes)
        UserDefaults.standard.set(data, forKey: memoryGameThemesKey)
    }
    
    private func load(){
        if let data = UserDefaults.standard.data(forKey: memoryGameThemesKey),
           let json = try? JSONDecoder().decode([Theme].self, from: data){
            themes = json
            print(json)
        }
    }
    
    init(storeName: String){
        
        self.storeName = storeName
        
        // load saved themese
        load()
        
        
        //load default theme
        if themes.isEmpty{
            let emojisVehicles : Set<String> = ["🚘","🚄","🏍","🛬","🛩","🚁","🚢","💺","🚲","🚑","🚃","🚕"]
            let emojisPerson: Set<String> = ["👮🏻‍♀️","🧑‍🎤","👩‍🏭","👨‍🌾","👩‍💻","🧑‍💼","👨‍🔧","👩‍🔬","🧑‍🎨","🧑‍🚒","🧑‍✈️","🧑‍🚀","👩‍⚖️"]
            let emojisSports: Set<String> = ["⚽️","🏀","🏈","⚾️","🥎", "🎾" ,"🏐" ,"🏉" ,"🥏" ,"🎱" ,"🏓" ,"🏸" ,"🏒"]
            let theme1 = Theme(name: "VehiclesFull", emojis: emojisVehicles, pairs: nil, color: Color.red)
            let theme2 = Theme(name: "Vehicles4", emojis: emojisVehicles , pairs: 4, color: .blue)
            let theme3 = Theme(name: "PersonFull", emojis: emojisPerson , pairs: nil, color: .green)
            let theme4 = Theme(name: "Person3", emojis: emojisPerson, pairs: 3, color: .yellow)
            let theme5 = Theme(name: "SportsFull", emojis: emojisSports, pairs: nil, color: .green)
            let theme6 = Theme(name: "Sports6", emojis: emojisSports , pairs: 6, color: .blue)
            
            themes = [theme1,theme2,theme3,theme4,theme5,theme6]
            print("is empty, loading default")
        }
        
        
    }

    // MARK: - Intent
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    
}


// create a Color from RGBAColor
extension Color  {
    init(rgbaColor rgba: RGBAColor ){
        self.init(.sRGB, red : rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha )
    }
}


extension Theme{
    //new initialized that allows you to create a theme using a Color (e.g .red )
    init(name: String, emojis : Set<String>, pairs : Int?, color : Color) {
            self.init(name: name,emojis: emojis,pairs: pairs, RGBAColor: RGBAColor(color))
    }
    
    //this allow your viewmodels to get directly a Color from your Theme ( like .red )
    var color : Color {
        set{self.cardColor = RGBAColor(newValue)}
        get{return Color(rgbaColor: self.cardColor)}
    }
    
}


// create a RGBAColor from a Color
extension RGBAColor  {
    init(_ color: Color){
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue:CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}
