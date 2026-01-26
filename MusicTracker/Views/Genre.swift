//
//  Genre.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Genre: View {
    let Genre: MPMediaItemCollection
    
    var albums: [MPMediaItemCollection] {
        if let id = Genre.representativeItem?.genrePersistentID {
            return MediaLibraryHelper.getAlbums(forGenre: id)
        }
        return []
    }
    
    var body: some View {
         GeometryReader { geo in
             ZStack {
                 // Background
                 RadialGradient(gradient: Gradient(colors: [.orange.opacity(0.2), .black]), center: .center, startRadius: 0, endRadius: 800)
                     .ignoresSafeArea()
                 
                 ScrollView {
                     VStack(alignment: .leading, spacing: 20) {
                         Color.clear.frame(height: 20) // Spacing for Nav Bar
                         // Header
                         VStack(spacing: 8) {

                             
                             Text(Genre.representativeItem?.genre ?? "Unknown Genre")
                                 .font(.system(size: 32, weight: .bold, design: .serif))
                                 .foregroundStyle(.primary)
                         }
                         .frame(maxWidth: .infinity)
                         .padding(.vertical, 40)
                         
                         Text("Albums")
                             .font(.title2)
                             .fontWeight(.bold)
                             .padding(.horizontal)
                         
                         // Album Grid
                         LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
                             ForEach(albums, id: \.persistentID) { album in
                                 NavigationLink(value: MusicRoute.albumDetail(album)) {
                                     VStack(alignment: .leading) {
                                         if let artwork = album.representativeItem?.artwork?.image(at: CGSize(width: 300, height: 300)) {
                                             Image(uiImage: artwork)
                                                 .resizable()
                                                 .scaledToFill()
                                                 .frame(width: 150, height: 150)
                                                 .cornerRadius(12)
                                         } else {
                                             Rectangle()
                                                 .fill(Material.thin)
                                                 .frame(width: 150, height: 150)
                                                 .cornerRadius(12)
                                         }
                                         
                                         Text(album.representativeItem?.albumTitle ?? "Untitled")
                                             .font(.headline)
                                             .lineLimit(1)
                                             .foregroundStyle(.primary)
                                         
                                         Text(album.representativeItem?.artist ?? "Unknown Artist")
                                              .font(.caption)
                                              .lineLimit(1)
                                              .foregroundStyle(.secondary)
                                         
                                         let totalPlays = album.items.reduce(0) { $0 + $1.playCount }
                                         HStack(spacing: 4) {
                                            Image(systemName: "play.circle.fill")
                                               .font(.caption2)
                                            Text("\(totalPlays)")
                                               .font(.caption)
                                         }
                                         .foregroundStyle(.secondary)
                                     }
                                     .padding()
                                     .background(Material.ultraThin)
                                     .cornerRadius(16)
                                 }
                                 .buttonStyle(.plain)
                             }
                         }
                         .padding(.horizontal)
                         
                         Spacer(minLength: 50)
                     }
                 }
             }
         }
         .navigationBarTitleDisplayMode(.inline)
    }
}
