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
    
    @State var selectedAlbum : MPMediaItemCollection = MPMediaItemCollection(items: [])
    @State var showAlbum : Bool = false
    
    var body: some View {
        ZStack{
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
                        Button(
                            action: {
                                selectedAlbum = album
                                showAlbum = true
                            },
                            label: {
                                HStack{
                                    Text("\(index + 1)")
                                    AlbumListItem(album: album)
                                }
                            }
                        )
                    }
                }
            }
            if(showAlbum)
            {
                Album(Album: selectedAlbum, showAlbum: $showAlbum)
            }
        }
        .background(Color(.systemBackground))
    }
}
