//
//  Genres.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Genres: View {
    @State var topGenres: [MPMediaItemCollection]
    
    var body: some View {
        VStack{
            Text("Genres")
        }
    }
}
