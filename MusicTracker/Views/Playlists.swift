//
//  Playlists.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Playlists: View {
    @State var topPlaylists: [MPMediaPlaylist]
    @Binding var showAllPlaylists: Bool
    
    var body: some View {
        VStack{
            ZStack{
                Text("Playlists")
                HStack{
                    Button("Back") {
                        showAllPlaylists = false
                    }
                    Spacer()
                }
            }
            List {
                ForEach(Array(topPlaylists.enumerated()), id: \.offset) { index, playlist in
                    HStack{
                        Text("\(index + 1)")
                        PlaylistListItem(playlist: playlist)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}
