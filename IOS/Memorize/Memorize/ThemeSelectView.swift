//
//  ThemeSelectView.swift
//  Memorize
//
//  Created by user225661 on 8/6/22.
//

import SwiftUI

struct ThemeSelectView: View {
    
    @ObservedObject var store : ThemeStore
    @State var games : [String: EmojiMemoryGame] = [:]

    
    //init(store : ThemeStore){
      //  var games : [String:EmojiMemoryGame] = [:]
       // self.store = store
       // for theme in store.themes{
        ////    games[theme.name] = EmojiMemoryGame(theme: theme)
        //}
        //self.games = games
    //}

    @State private var editMode : EditMode = .inactive
    
    @State var popover : Bool = false
    
    
    var body: some View {

        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    //ThemeEditor(theme: $theme)
                    NavigationLink(destination :EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))){
                            HStack{
                                Text(theme.name)
                                theme.color
                                    .cardify(isFaceUp: false, color: theme.color)
                                    .frame(maxWidth: 25,  maxHeight: 50)
                                Text(Array(theme.emojis)[0])
                                Text(Array(theme.emojis)[1])
                                Text(Array(theme.emojis)[2])
                                Spacer()
                                
                            }
                    }.gesture(editMode == .active ? tap : nil)
                }
                .onDelete{ indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove{ indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                    
                }
            }
            .navigationTitle("Choose a Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    //NavigationLink("new",destination: ThemeEditor(theme: $store.themes[0]))
                    //}
                    //Button("New"){
                      //  popover = true
                        
                        
                    //}
                    Button {
                        //NavigationLink("new",destination: ThemeEditor(theme: $store.themes[0]))
                        popover = true
                    } label: {
                        Text("New")
                    }

                        
                }
                ToolbarItem { EditButton() }

                   
                
                
            }
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $popover){
                ThemeEditor(theme: $store.themes.last!)
            }

        }
         
        
        
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
}







struct ThemeSelectView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let store : ThemeStore = ThemeStore(storeName: "preview")

        ThemeSelectView(store: store)
    }
}




