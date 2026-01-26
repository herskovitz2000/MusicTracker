//
//  Playlist.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Playlist: View {
    let Playlist: MPMediaPlaylist
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                LinearGradient(colors: [.indigo.opacity(0.3), .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                         Color.clear.frame(height: 20) // Spacing for Nav Bar
                        // Header
                        HStack(alignment: .top, spacing: 20) {
                             // Playlist Artwork? Usually tricky, often a mosaic or first item artwork.
                             if let firstItem = Playlist.items.first, let artwork = firstItem.artwork?.image(at: CGSize(width: 200, height: 200)) {
                                 Image(uiImage: artwork)
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: 140, height: 140)
                                     .cornerRadius(8)
                                     .shadow(radius: 10)
                             } else {
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    Image(systemName: "music.note.list")
                                        .font(.largeTitle)
                                }
                                .frame(width: 140, height: 140)
                                .cornerRadius(8)
                             }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(Playlist.name ?? "Playlist")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                if let desc = Playlist.descriptionText, !desc.isEmpty {
                                    Text(desc)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(3)
                                }
                                
                                Text("\(Playlist.items.count) Songs")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        
                        Divider().padding(.horizontal)
                        
                        // Songs List
                        LazyVStack(spacing: 0) {
                            ForEach(Array(Playlist.items.enumerated()), id: \.element.persistentID) { index, song in
                                NavigationLink(value: MusicRoute.songDetail(song)) {
                                    HStack(spacing: 16) {
                                        Text("\(index + 1)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 24)
                                        
                                        VStack(alignment: .leading) {
                                            Text(song.title ?? "Unknown")
                                                .font(.body)
                                                .foregroundStyle(.primary)
                                            Text(song.artist ?? "Unknown Artist")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            HStack(spacing: 4) {
                                              Image(systemName: "play.circle.fill")
                                                 .font(.caption2)
                                              Text("\(song.playCount)")
                                                 .font(.caption)
                                           }
                                           .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.clear)
                                }
                                .buttonStyle(.plain)
                                Divider().padding(.leading, 50)
                            }
                        }
                        .background(Material.thin)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
