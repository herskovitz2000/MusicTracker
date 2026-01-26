//
//  Genres.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Genres: View {
    let topGenres: [MPMediaItemCollection]
    
    var body: some View {
        List {
            ForEach(Array(topGenres.enumerated()), id: \.offset) { index, genre in
                NavigationLink(value: MusicRoute.genreDetail(genre)) {
                    HStack{
                        Text("\(index + 1)")
                            .foregroundStyle(.secondary)
                        GenreListItem(genre: genre)
                    }
                }
            }
        }
        .navigationTitle("Genres")
        .navigationBarTitleDisplayMode(.inline)
    }
}
