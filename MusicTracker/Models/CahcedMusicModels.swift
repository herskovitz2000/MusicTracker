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
    let releaseDate: Date?
    let composer: String
    let year: Int
    let trackCount: Int
    let discNumber: Int
    let discCount: Int
    let lyrics: String?
    
    init(from mediaItem: MPMediaItem) {
        self.persistentID = mediaItem.persistentID
        self.title = mediaItem.title ?? "Unknown Title"
        self.artist = mediaItem.artist ?? "Unknown Artist"
        self.album = mediaItem.albumTitle ?? "Unknown Album"
        self.playCount = mediaItem.playCount
        self.playbackDuration = mediaItem.playbackDuration
        self.genre = mediaItem.genre ?? "Unknown Genre"
        self.releaseDate = mediaItem.releaseDate
        self.composer = mediaItem.composer ?? ""
        
        // Handle year safely if possible, though MPMediaItem doesn't expose it directly as Int always easily.
        // We can try to parse it from releaseDate if year property isn't available or reliable on older iOS versions.
        // MPMediaItemPropertyReleaseDate is available.
        if let date = mediaItem.releaseDate {
             self.year = Calendar.current.component(.year, from: date)
        } else {
             self.year = 0
        }
        
        self.trackCount = mediaItem.albumTrackCount
        self.discNumber = mediaItem.discNumber
        self.discCount = mediaItem.discCount
        self.lyrics = mediaItem.lyrics
    }
}

struct CachedAlbum: Codable {
    let representativeItemPersistentID: UInt64
    let title: String
    let artist: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    let trackCount: Int
    let releaseDate: Date?
    let genre: String
    
    init(from collection: MPMediaItemCollection) {
        self.representativeItemPersistentID = collection.representativeItem?.persistentID ?? 0
        self.title = collection.representativeItem?.albumTitle ?? "Unknown Album"
        self.artist = collection.representativeItem?.albumArtist ?? collection.representativeItem?.artist ?? "Unknown Artist"
        self.totalPlayCount = collection.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = collection.items.map { $0.persistentID }
        self.trackCount = collection.count
        self.releaseDate = collection.representativeItem?.releaseDate
        self.genre = collection.representativeItem?.genre ?? "Unknown Genre"
    }
}

struct CachedArtist: Codable {
    let representativeItemPersistentID: UInt64
    let name: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    let genre: String?
    
    init(from collection: MPMediaItemCollection) {
        self.representativeItemPersistentID = collection.representativeItem?.persistentID ?? 0
        self.name = collection.representativeItem?.artist ?? "Unknown Artist"
        self.totalPlayCount = collection.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = collection.items.map { $0.persistentID }
        // Attempt to find a common genre or just pick the first one
        self.genre = collection.representativeItem?.genre
    }
}

struct CachedPlaylist: Codable {
    let persistentID: UInt64
    let name: String
    let totalPlayCount: Int
    let songPersistentIDs: [UInt64]
    let description: String?
    let author: String?
    
    init(from playlist: MPMediaPlaylist) {
        self.persistentID = playlist.persistentID
        self.name = playlist.name ?? "Unknown Playlist"
        self.totalPlayCount = playlist.items.reduce(0) { $0 + $1.playCount }
        self.songPersistentIDs = playlist.items.map { $0.persistentID }
        self.description = playlist.descriptionText
        self.author = playlist.authorDisplayName
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

// MARK: - Equatable Conformance
extension CachedSong: Equatable {
    static func == (lhs: CachedSong, rhs: CachedSong) -> Bool {
        lhs.persistentID == rhs.persistentID
    }
}

extension CachedAlbum: Equatable {
    static func == (lhs: CachedAlbum, rhs: CachedAlbum) -> Bool {
        lhs.representativeItemPersistentID == rhs.representativeItemPersistentID
    }
}

extension CachedArtist: Equatable {
    static func == (lhs: CachedArtist, rhs: CachedArtist) -> Bool {
        lhs.representativeItemPersistentID == rhs.representativeItemPersistentID
    }
}

extension CachedPlaylist: Equatable {
    static func == (lhs: CachedPlaylist, rhs: CachedPlaylist) -> Bool {
        lhs.persistentID == rhs.persistentID
    }
}

extension CachedGenre: Equatable {
    static func == (lhs: CachedGenre, rhs: CachedGenre) -> Bool {
        lhs.representativeItemPersistentID == rhs.representativeItemPersistentID
    }
}
