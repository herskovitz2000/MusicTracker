//
//  Album.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Album: View {
    let Album: MPMediaItemCollection
    
    // Derived Data
    var artistCollection: MPMediaItemCollection? {
        if let artistID = Album.representativeItem?.artistPersistentID {
             return MediaLibraryHelper.getArtist(by: artistID)
        }
        return nil
    }
    
    var songs: [MPMediaItem] {
        if let id = Album.representativeItem?.albumPersistentID {
            return MediaLibraryHelper.getSongs(forAlbum: id)
        }
        return Album.items
    }
    
    var totalDuration: String {
        let total = songs.reduce(0) { $0 + $1.playbackDuration }
        let h = Int(total / 3600)
        let m = (Int(total) % 3600) / 60
        if h > 0 {
            return "\(h) hr \(m) min"
        }
        return "\(m) min"
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Dimmed Background
                if let artwork = Album.representativeItem?.artwork?.image(at: CGSize(width: 500, height: 500)) {
                    Image(uiImage: artwork)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .blur(radius: 50)
                        .opacity(0.5)
                } else {
                    Color.black.opacity(0.8)
                }
                
                ScrollView {
                     VStack(alignment: .leading, spacing: 20) {
                        Color.clear.frame(height: 20) // Spacing for Nav Bar
                        // Header
                        HStack(alignment: .bottom, spacing: 20) {
                            if let artworkImage = Album.representativeItem?.artwork?.image(at: CGSize(width: 200, height: 200)) {
                                Image(uiImage: artworkImage)
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .cornerRadius(12)
                                    .shadow(radius: 10)
                            } else {
                                Rectangle()
                                    .fill(Material.thin)
                                    .frame(width: 160, height: 160)
                                    .cornerRadius(12)
                                    .overlay(
                                        Image(systemName: "square.stack")
                                            .font(.largeTitle)
                                            .foregroundStyle(.secondary)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(Album.representativeItem?.albumTitle ?? "Unknown Album")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                if let artist = artistCollection {
                                    NavigationLink(value: MusicRoute.artistDetail(artist)) {
                                        Text(artist.representativeItem?.artist ?? "Unknown Artist")
                                            .font(.title3)
                                            .foregroundStyle(.blue)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    Text(Album.representativeItem?.artist ?? "Unknown Artist")
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text("\(songs.count) Songs")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text(Album.representativeItem?.genre ?? "Genre")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(6)
                                    .background(Material.ultraThin)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
                        Divider().padding(.horizontal)
                        
                        // Tracklist
                        Text("Tracks")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 0) {
                            ForEach(Array(songs.enumerated()), id: \.element.persistentID) { index, song in
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
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "play.circle.fill")
                                                    .font(.caption2)
                                                Text("\(song.playCount)")
                                                    .font(.caption)
                                            }
                                            .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        let duration = song.playbackDuration
                                        Text("\(Int(duration) / 60):\(String(format: "%02d", Int(duration) % 60))")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .background(Color.clear) // Tappable area
                                }
                                .buttonStyle(.plain)
                                
                                Divider().padding(.leading, 50)
                            }
                        }
                        .background(Material.thin)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        

                        HStack {
                            let totalPlays = songs.reduce(0) { $0 + $1.playCount }
                            Text("Total Plays: \(totalPlays)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
