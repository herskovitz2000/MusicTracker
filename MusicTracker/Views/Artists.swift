//
//  Artists.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Artists: View {
    @State var topArtists: [MPMediaItemCollection]
    @Binding var showAllArtists: Bool
    
    var body: some View {
        VStack{
            ZStack{
                Text("Artists")
                HStack{
                    Button("Back") {
                        showAllArtists = false
                    }
                    Spacer()
                }
            }
            List {
                ForEach(Array(topArtists.enumerated()), id: \.offset) { index, artist in
                    HStack{
                        Text("\(index + 1)")
                        ArtistListItem(artist: artist)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}
