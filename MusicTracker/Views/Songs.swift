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
    
    @State var selectedSong : MPMediaItem = MPMediaItem()
    @State var showSong = false
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
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
                            Button(
                                action: {
                                    selectedSong = song
                                    showSong = true
                                },
                                label: {
                                    HStack{
                                        Text("\(index + 1)")
                                        SongListItem(song: song)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            if(showSong)
            {
                Song(Song: selectedSong, showSong: $showSong)
            }
        }
        .background(Color(.systemBackground))
        //.ignoresSafeArea()
    }
}
