//
//  Playlist.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Playlist: View {
    @State var Playlist: MPMediaPlaylist
    @Binding var showPlaylist : Bool
    
    var totalPlayCount: Int {
            Playlist.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        VStack{
            ZStack{
                Text(Playlist.name ?? "")
                HStack{
                    Button("Back") {
                        showPlaylist = false
                    }
                    Spacer()
                }
            }
            if let artworkImage = Playlist.representativeItem?.artwork?.image(at: CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)) {
                Image(uiImage: artworkImage)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                    .cornerRadius(4)
            } else {
                // Placeholder if there's no artwork
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                    .cornerRadius(4)
                    .overlay(
                        Text("No Art")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    )
            }
            Text("\(totalPlayCount) total plays")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}
