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
    
    @State var selectedPlaylist : MPMediaPlaylist = MPMediaPlaylist(items: [])
    @State var showPlaylist : Bool = false
    
    var body: some View {
        ZStack{
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
                        Button(
                            action: {
                                selectedPlaylist = playlist
                                showPlaylist = true
                            },
                            label: {
                                HStack{
                                    Text("\(index + 1)")
                                    PlaylistListItem(playlist: playlist)
                                }
                            }
                        )
                    }
                }
            }
            if(showPlaylist)
            {
                Playlist(Playlist: selectedPlaylist, showPlaylist: $showPlaylist)
            }
        }
        .background(Color(.systemBackground))
    }
}
