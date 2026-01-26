//
//  Songs.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Songs: View {
    let topSongs: [MPMediaItem]
    
    var body: some View {
        List {
            ForEach(Array(topSongs.enumerated()), id: \.offset) { index, song in
                NavigationLink(value: MusicRoute.songDetail(song)) {
                    HStack{
                        Text("\(index + 1)")
                            .foregroundStyle(.secondary)
                        SongListItem(song: song)
                    }
                }
            }
        }
        .navigationTitle("Songs")
        .navigationBarTitleDisplayMode(.inline)
    }
}
