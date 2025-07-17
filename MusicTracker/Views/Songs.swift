//
//  Songs.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Songs: View {
    @State var topSongs: [MPMediaItem]
    @Binding var showAllSongs: Bool
    
    var body: some View {
        VStack{
            ZStack{
                Text("Songs")
                HStack{
                    Button("Back") {
                        showAllSongs = false
                    }
                    Spacer()
                }
            }
            List {
                ForEach(Array(topSongs.enumerated()), id: \.offset) { index, song in
                    HStack{
                        Text("\(index + 1)")
                        SongListItem(song: song)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}
