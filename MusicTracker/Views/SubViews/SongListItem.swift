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
            if let artworkImage = song.artwork?.image(at: CGSize(width: 44, height: 44)) {
                Image(uiImage: artworkImage)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .cornerRadius(4)
            } else {
                // Placeholder if there's no artwork
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .cornerRadius(4)
                    .overlay(
                        Text("No Art")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    )
            }
            VStack (alignment: .leading){
                HStack{
                        Text(song.title ?? "Unknown Title" )
                            .font(.system(size: 12))
                        Text("-")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        Text((song.artist ?? "Unknown Artist"))
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                }
                Text("\(song.playCount) total plays")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
