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
    @Binding var showAllGenres: Bool
    
    var body: some View {
        VStack{
            ZStack{
                Text("Genres")
                HStack{
                    Button("Back") {
                        showAllGenres = false
                    }
                    Spacer()
                }
            }
            List {
                ForEach(Array(topGenres.enumerated()), id: \.offset) { index, genre in
                    HStack{
                        Text("\(index + 1)")
                        GenreListItem(genre: genre)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}
