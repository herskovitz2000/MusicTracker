//
//  Song.swift
//  MusicTrackr
//
//  Created by Nathan Herskovitz on 7/17/25.
//

import SwiftUI
import MediaPlayer

struct Song: View {
    let Song: MPMediaItem
    
    // Derived Data
    var artistCollection: MPMediaItemCollection? {
        MediaLibraryHelper.getArtist(by: Song.artistPersistentID)
    }
    
    var albumCollection: MPMediaItemCollection? {
        MediaLibraryHelper.getAlbum(by: Song.albumPersistentID)
    }
    
    var releaseYear: String {
        if let date = Song.releaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }
        return "Unknown Year"
    }

    var durationString: String {
        let minutes = Int(Song.playbackDuration / 60)
        let seconds = Int(Song.playbackDuration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                if let artwork = Song.artwork?.image(at: CGSize(width: 500, height: 500)) {
                    Image(uiImage: artwork)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .blur(radius: 60)
                        .opacity(0.6)
                } else {
                    Color.black.opacity(0.8)
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        Color.clear.frame(height: 20) // Spacing for Nav Bar
                        // Hero Artwork
                        if let artworkImage = Song.artwork?.image(at: CGSize(width: 300, height: 300)) {
                            Image(uiImage: artworkImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 280, height: 280)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                                .padding(.top, 40)
                        } else {
                            Rectangle()
                                .fill(Material.ultraThin)
                                .frame(width: 280, height: 280)
                                .cornerRadius(20)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.system(size: 80))
                                        .foregroundStyle(.secondary)
                                )
                                .padding(.top, 40)
                        }
                        
                        // Title & Check-ins
                        VStack(spacing: 8) {
                            Text(Song.title ?? "Unknown Title")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.primary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "play.circle.fill")
                                Text("\(Song.playCount) Plays")
                            }
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Material.thin)
                            .clipShape(Capsule())
                        }
                        
                        // Links (Artist & Album)
                        HStack(spacing: 20) {
                            if let artist = artistCollection {
                                NavigationLink(value: MusicRoute.artistDetail(artist)) {
                                    VStack {
                                        Image(systemName: "mic.fill")
                                            .font(.title2)
                                            .padding(12)
                                            .background(Color.pink.opacity(0.2))
                                            .clipShape(Circle())
                                        Text(artist.representativeItem?.artist ?? "Artist")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 100)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            if let album = albumCollection {
                                NavigationLink(value: MusicRoute.albumDetail(album)) {
                                    VStack {
                                        Image(systemName: "square.stack.3d.down.right.fill")
                                            .font(.title2)
                                            .padding(12)
                                            .background(Color.blue.opacity(0.2))
                                            .clipShape(Circle())
                                        Text(album.representativeItem?.albumTitle ?? "Album")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 100)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical)
                        
                        // Metadata Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            DetailCard(title: "Genre", value: Song.genre ?? "Unknown", icon: "guitars.fill")
                            DetailCard(title: "Year", value: releaseYear, icon: "calendar")
                            DetailCard(title: "Duration", value: durationString, icon: "clock.fill")
                            DetailCard(title: "Composer", value: Song.composer ?? "Unknown", icon: "music.quarternote.3")
                        }
                        .padding(.horizontal)
                        
                        if let lyrics = Song.lyrics, !lyrics.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Lyrics")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Text(lyrics)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Material.thin)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Material.thin)
        .cornerRadius(12)
    }
}
