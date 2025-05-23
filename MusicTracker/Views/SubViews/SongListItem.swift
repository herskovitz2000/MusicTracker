//
//  TopSongs.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 5/12/25.
//

import SwiftUI
import MediaPlayer

struct SongListItem: View {
    @State var song : MPMediaItem
    
    var body: some View {
        HStack{
            VStack{
                Text(song.title ?? "Unknown Title" )
                    .font(.system(size: 12))
                Text(song.artist ?? "Unknown Artist")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
        }
    }
}
