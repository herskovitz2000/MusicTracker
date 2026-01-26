//
//  Albums.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 6/4/25.
//

import SwiftUI
import MediaPlayer

struct Albums: View {
    let topAlbums: [MPMediaItemCollection]
    
    var body: some View {
        List {
            ForEach(Array(topAlbums.enumerated()), id: \.offset) { index, album in
                NavigationLink(value: MusicRoute.albumDetail(album)) {
                    HStack{
                        Text("\(index + 1)")
                            .foregroundStyle(.secondary)
                        AlbumListItem(album: album)
                    }
                }
            }
        }
        .navigationTitle("Albums")
        .navigationBarTitleDisplayMode(.inline)
    }
}
