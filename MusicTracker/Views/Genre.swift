//
//  Genre.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Genre: View {
    @State var Genre: MPMediaItemCollection
    @Binding var showGenre : Bool
    
    var totalPlayCount: Int {
            Genre.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        VStack{
            ZStack{
                Text(Genre.representativeItem?.genre ?? "Unknown Genre" )
                HStack{
                    Button("Back") {
                        showGenre = false
                    }
                    Spacer()
                }
            }
            if let artworkImage = Genre.representativeItem?.artwork?.image(at: CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)) {
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
