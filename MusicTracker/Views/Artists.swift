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
    
    @State var selectedArtist : MPMediaItemCollection = MPMediaItemCollection(items: [])
    @State var showArtist : Bool = false
    
    var body: some View {
        ZStack
        {
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
                        Button(
                            action: {
                                selectedArtist = artist
                                showArtist = true
                            },
                            label: {
                                HStack{
                                    Text("\(index + 1)")
                                    ArtistListItem(artist: artist)
                                }
                            }
                        )
                    }
                }
            }
            if(showArtist)
            {
                Artist(Artist: selectedArtist, showArtist: $showArtist)
            }
        }
        .background(Color(.systemBackground))
    }
}
