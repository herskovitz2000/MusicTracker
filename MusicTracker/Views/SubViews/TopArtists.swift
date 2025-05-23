//
//  TopArtists.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 5/12/25.
//

import SwiftUI
import MediaPlayer

struct TopArtists: View {
    @State var topArtists: [MPMediaItemCollection]
    
    var body: some View {
        VStack{
            Text("Top Artists")
            HStack{
                Text("1.")
                ArtistListItem(artist: topArtists[0])
            }
            HStack{
                Text("2.")
                ArtistListItem(artist: topArtists[1])
            }
            HStack{
                Text("3.")
                ArtistListItem(artist: topArtists[2])
            }
        }
    }
}
