//
//  TopSongs.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 5/12/25.
//

import SwiftUI
import MediaPlayer

struct TopSongs: View {
    @State var topSongs : [MPMediaItem]
    
    var body: some View {
        VStack{
            Text("Top Songs")
            HStack{
                Text("1.")
                SongListItem(song: topSongs[0])
            }
            HStack{
                Text("2.")
                SongListItem(song: topSongs[1])
            }
            HStack{
                Text("3.")
                SongListItem(song: topSongs[2])
            }
        }
    }
}
