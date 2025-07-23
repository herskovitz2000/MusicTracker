import Foundation
import MediaPlayer

// MARK: - Cached Models
struct CachedSong: Codable {
    let persistentID: UInt64
    let title: String
    let artist: String
    let album: String
    let playCount: Int
    let playbackDuration: TimeInterval
    let genre: String
    
    init(from mediaItem: MPMediaItem) {
        self.persistentID = mediaItem.persistentID
        self.title = mediaItem.title ?? "Unknown Title"
        self.artist = mediaItem.artist ?? "Unknown Artist"
        self.album = mediaItem.albumTitle ?? "Unknown Album"
        self.playCount = mediaItem.playCount
        self.playbackDuration = mediaItem.playbackDuration
        self.genre = mediaItem.genre ?? "Unknown Genre"
    }
}

struct CachedAlbum: Codable {
    let representativeItemPersistentID: UInt64
    let title: String
    let artist: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    
    init(from collection: MPMediaItemCollection) {
        self.representativeItemPersistentID = collection.representativeItem?.persistentID ?? 0
        self.title = collection.representativeItem?.albumTitle ?? "Unknown Album"
        self.artist = collection.representativeItem?.albumArtist ?? collection.representativeItem?.artist ?? "Unknown Artist"
        self.totalPlayCount = collection.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = collection.items.map { $0.persistentID }
    }
}

struct CachedArtist: Codable {
    let representativeItemPersistentID: UInt64
    let name: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    
    init(from collection: MPMediaItemCollection) {
        self.representativeItemPersistentID = collection.representativeItem?.persistentID ?? 0
        self.name = collection.representativeItem?.artist ?? "Unknown Artist"
        self.totalPlayCount = collection.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = collection.items.map { $0.persistentID }
    }
}

struct CachedPlaylist: Codable {
    let persistentID: UInt64
    let name: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    
    init(from playlist: MPMediaPlaylist) {
        self.persistentID = playlist.persistentID
        self.name = playlist.name ?? "Unknown Playlist"
        self.totalPlayCount = playlist.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = playlist.items.map { $0.persistentID }
    }
}

struct CachedGenre: Codable {
    let representativeItemPersistentID: UInt64
    let name: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    
    init(from collection: MPMediaItemCollection) {
        self.representativeItemPersistentID = collection.representativeItem?.persistentID ?? 0
        self.name = collection.representativeItem?.genre ?? "Unknown Genre"
        self.totalPlayCount = collection.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = collection.items.map { $0.persistentID }
    }
}

// MARK: - Cache Container
struct MusicCache: Codable {
    let songs: [CachedSong]
    let albums: [CachedAlbum]
    let artists: [CachedArtist]
    let playlists: [CachedPlaylist]
    let genres: [CachedGenre]
    let totalSeconds: TimeInterval
    let cacheDate: Date
    
    init(songs: [MPMediaItem], albums: [MPMediaItemCollection], artists: [MPMediaItemCollection],
         playlists: [MPMediaPlaylist], genres: [MPMediaItemCollection], totalSeconds: TimeInterval) {
        self.songs = songs.map { CachedSong(from: $0) }
        self.albums = albums.map { CachedAlbum(from: $0) }
        self.artists = artists.map { CachedArtist(from: $0) }
        self.playlists = playlists.map { CachedPlaylist(from: $0) }
        self.genres = genres.map { CachedGenre(from: $0) }
        self.totalSeconds = totalSeconds
        self.cacheDate = Date()
    }
}
