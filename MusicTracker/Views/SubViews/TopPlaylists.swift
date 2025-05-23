//
//  TopPlaylists.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 5/12/25.
//

import SwiftUI
import MediaPlayer

struct TopPlaylists: View {
    @State var topPlaylists: [MPMediaPlaylist]
    
    var body: some View {
        VStack{
            Text("Top Playlists")
            HStack{
                Text("1.")
                PlaylistListItem(playlist: topPlaylists[0])
            }
            HStack{
                Text("2.")
                PlaylistListItem(playlist: topPlaylists[1])
            }
            HStack{
                Text("3.")
                PlaylistListItem(playlist: topPlaylists[2])
            }
        }
    }
}
