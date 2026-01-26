//
//  Artist.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Artist: View {
    let Artist: MPMediaItemCollection
    
    // Derived Data
    var albums: [MPMediaItemCollection] {
        if let id = Artist.representativeItem?.artistPersistentID {
            // Sort by release date descending
            return MediaLibraryHelper.getAlbums(forArtist: id).sorted {
                ($0.representativeItem?.releaseDate ?? Date.distantPast) > ($1.representativeItem?.releaseDate ?? Date.distantPast)
            }
        }
        return []
    }
    
    var body: some View {
         GeometryReader { geo in
             ZStack {
                 // Background (Abstract or gradient)
                 LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                     .ignoresSafeArea()
                 
                 ScrollView {
                     VStack(alignment: .leading, spacing: 20) {
                         Color.clear.frame(height: 20) // Spacing for Nav Bar
                         // Hero Header
                         VStack(spacing: 16) {
                             if let artwork = Artist.representativeItem?.artwork?.image(at: CGSize(width: 300, height: 300)) {
                                 Image(uiImage: artwork)
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: 140, height: 140)
                                     .clipShape(Circle())
                                     .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 4))
                                     .shadow(radius: 10)
                             } else {
                                 Image(systemName: "mic.fill")
                                     .resizable()
                                     .padding(40)
                                     .frame(width: 140, height: 140)
                                     .background(Material.thick)
                                     .clipShape(Circle())
                             }
                             
                             Text(Artist.representativeItem?.artist ?? "Unknown Artist")
                                 .font(.system(size: 32, weight: .bold, design: .rounded))
                                 .foregroundStyle(.primary)
                         }
                         .frame(maxWidth: .infinity)
                         .padding(.top, 40)
                         .padding(.bottom, 20)
                         
                         Text("Albums")
                             .font(.title2)
                             .fontWeight(.bold)
                             .padding(.horizontal)
                         
                         // Album Grid or List
                         // Using Grid for albums looks nicer
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
                                                 .overlay(Image(systemName: "music.note"))
                                         }
                                         
                                         Text(album.representativeItem?.albumTitle ?? "Untitled")
                                             .font(.headline)
                                             .lineLimit(1)
                                             .foregroundStyle(.primary)
                                         
                                         Text("\(album.count) Songs")
                                             .font(.caption)
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
