//
//  TopGenres.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 5/12/25.
//

import SwiftUI
import MediaPlayer

struct TopGenres: View {
    @State var topGenres: [MPMediaItemCollection]
    
    var body: some View {
        VStack{
            Text("Top Genres")
            HStack{
                Text("1.")
                GenreListItem(genre: topGenres[0])
            }
            HStack{
                Text("2.")
                GenreListItem(genre: topGenres[1])
            }
            HStack{
                Text("3.")
                GenreListItem(genre: topGenres[2])
            }
        }
    }
}
