//
//  Albums.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Albums: View {
    @State var topAlbums: [MPMediaItemCollection]
    @Binding var showAllAlbums : Bool
    
    var body: some View {
        VStack{
            ZStack{
                Text("Albums")
                HStack{
                    Button("Back") {
                        showAllAlbums = false
                    }
                    Spacer()
                }
            }
            List {
                ForEach(Array(topAlbums.enumerated()), id: \.offset) { index, album in
                    HStack{
                        Text("\(index + 1)")
                        AlbumListItem(album: album)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}
