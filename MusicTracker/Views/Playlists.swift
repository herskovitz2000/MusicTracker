//
//  Playlists.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Playlists: View {
    let topPlaylists: [MPMediaPlaylist]
    
    var body: some View {
        List {
            ForEach(Array(topPlaylists.enumerated()), id: \.offset) { index, playlist in
                NavigationLink(value: MusicRoute.playlistDetail(playlist)) {
                    HStack{
                        Text("\(index + 1)")
                            .foregroundStyle(.secondary)
                        PlaylistListItem(playlist: playlist)
                    }
                }
            }
        }
        .navigationTitle("Playlists")
        .navigationBarTitleDisplayMode(.inline)
    }
}
