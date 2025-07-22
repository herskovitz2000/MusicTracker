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
    
    @State var selectedGenre : MPMediaItemCollection = MPMediaItemCollection(items: [])
    @State var showGenre : Bool = false
    
    var body: some View {
        ZStack{
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
                        Button(
                            action: {
                                selectedGenre = genre
                                showGenre = true
                            },
                            label: {
                                HStack{
                                    Text("\(index + 1)")
                                    GenreListItem(genre: genre)
                                }
                            }
                        )
                    }
                }
            }
            if(showGenre)
            {
                Genre(Genre: selectedGenre, showGenre: $showGenre)
            }
        }
        .background(Color(.systemBackground))
    }
}
