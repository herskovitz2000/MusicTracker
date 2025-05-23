//
//  TopAlbums.swift
//  MusicTracker
//
//  Created by Nathan Herskovitz on 5/12/25.
//

import SwiftUI
import MediaPlayer

struct TopAlbums: View {
    @State var topAlbums: [MPMediaItemCollection]
    
    var body: some View {
        VStack{
            Text("Top Albums")
            HStack{
                Text("1.")
                AlbumListItem(album: topAlbums[0])
            }
            HStack{
                Text("2.")
                AlbumListItem(album: topAlbums[1])
            }
            HStack{
                Text("3.")
                AlbumListItem(album: topAlbums[2])
            }
        }
    }
}
