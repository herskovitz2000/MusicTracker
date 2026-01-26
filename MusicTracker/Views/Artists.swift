//
//  Artists.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Artists: View {
    let topArtists: [MPMediaItemCollection]
    
    var body: some View {
        List {
            ForEach(Array(topArtists.enumerated()), id: \.offset) { index, artist in
                NavigationLink(value: MusicRoute.artistDetail(artist)) {
                    HStack{
                        Text("\(index + 1)")
                            .foregroundStyle(.secondary)
                        ArtistListItem(artist: artist)
                    }
                }
            }
        }
        .navigationTitle("Artists")
        .navigationBarTitleDisplayMode(.inline)
    }
}
