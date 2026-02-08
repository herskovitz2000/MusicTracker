import Foundation
import MediaPlayer

class MusicCacheManager {
    private static let cacheFileName = "musicCache.json"
    private static let maxCacheAge: TimeInterval = 24 * 60 * 60 // 24 hours
    
    // MARK: - File URL
    private static var cacheURL: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        return documentsPath.appendingPathComponent(cacheFileName)
    }
    
    static func saveCache(cache: MusicCache) async {
        
        await Task.detached(priority: .background) {
            do {
                let data = try JSONEncoder().encode(cache)
                try data.write(to: cacheURL)
                print("Cache saved successfully")
            } catch {
                print("Failed to save cache: \(error)")
            }
        }.value
    }
    
    // MARK: - Load Cache
    static func loadCache() async -> MusicCache? {
        await Task.detached(priority: .userInitiated) {
            guard FileManager.default.fileExists(atPath: cacheURL.path) else {
                print("Cache file does not exist")
                return nil
            }
            
            do {
                let data = try Data(contentsOf: cacheURL)
                let cache = try JSONDecoder().decode(MusicCache.self, from: data)
                
                // Check if cache is still valid (within maxCacheAge)
                if Date().timeIntervalSince(cache.cacheDate) > maxCacheAge {
                    print("Cache is too old, will refresh")
                    return nil
                }
                
                print("Cache loaded successfully")
                return cache
            } catch {
                print("Failed to load cache: \(error)")
                return nil
            }
        }.value
    }
    
    // MARK: - Clear Cache
    static func clearCache() {
        do {
            if FileManager.default.fileExists(atPath: cacheURL.path) {
                try FileManager.default.removeItem(at: cacheURL)
                print("Cache cleared successfully")
            }
        } catch {
            print("Failed to clear cache: \(error)")
        }
    }
    
    // MARK: - Convert Cached Data Back to Media Objects
    static func convertCacheToMediaObjects(cache: MusicCache) -> (songs: [MPMediaItem], albums: [MPMediaItemCollection], artists: [MPMediaItemCollection], playlists: [MPMediaPlaylist], genres: [MPMediaItemCollection]) {
        
        var songs: [MPMediaItem] = []
        var albums: [MPMediaItemCollection] = []
        var artists: [MPMediaItemCollection] = []
        var playlists: [MPMediaPlaylist] = []
        var genres: [MPMediaItemCollection] = []
        
        // Convert cached songs back to MPMediaItem objects
        let allSongsQuery = MPMediaQuery.songs()
        if let allSongs = allSongsQuery.items {
            let songDict = Dictionary(uniqueKeysWithValues: allSongs.map { ($0.persistentID, $0) })
            
            for cachedSong in cache.songs {
                if let mediaItem = songDict[cachedSong.persistentID] {
                    songs.append(mediaItem)
                }
            }
        }
        
        // Convert cached albums back to MPMediaItemCollection objects
        let allAlbumsQuery = MPMediaQuery.albums()
        if let allAlbums = allAlbumsQuery.collections {
            var albumDict: [UInt64: MPMediaItemCollection] = [:]
            for collection in allAlbums {
                if let repItem = collection.representativeItem {
                    albumDict[repItem.persistentID] = collection
                }
            }
            
            for cachedAlbum in cache.albums {
                if let collection = albumDict[cachedAlbum.representativeItemPersistentID] {
                    albums.append(collection)
                }
            }
        }
        
        // Convert cached artists back to MPMediaItemCollection objects
        let allArtistsQuery = MPMediaQuery.artists()
        if let allArtists = allArtistsQuery.collections {
            var artistDict: [UInt64: MPMediaItemCollection] = [:]
            for collection in allArtists {
                if let repItem = collection.representativeItem {
                    artistDict[repItem.persistentID] = collection
                }
            }
            
            for cachedArtist in cache.artists {
                if let collection = artistDict[cachedArtist.representativeItemPersistentID] {
                    artists.append(collection)
                }
            }
        }
        
        // Convert cached playlists back to MPMediaPlaylist objects
        let allPlaylistsQuery = MPMediaQuery.playlists()
        if let allPlaylists = allPlaylistsQuery.collections as? [MPMediaPlaylist] {
            let playlistDict = Dictionary(uniqueKeysWithValues: allPlaylists.map { ($0.persistentID, $0) })
            
            for cachedPlaylist in cache.playlists {
                if let playlist = playlistDict[cachedPlaylist.persistentID] {
                    playlists.append(playlist)
                }
            }
        }
        
        // Convert cached genres back to MPMediaItemCollection objects
        let allGenresQuery = MPMediaQuery.genres()
        if let allGenres = allGenresQuery.collections {
            var genreDict: [UInt64: MPMediaItemCollection] = [:]
            for collection in allGenres {
                if let repItem = collection.representativeItem {
                    genreDict[repItem.persistentID] = collection
                }
            }
            
            for cachedGenre in cache.genres {
                if let collection = genreDict[cachedGenre.representativeItemPersistentID] {
                    genres.append(collection)
                }
            }
        }
        
        return (songs: songs, albums: albums, artists: artists, playlists: playlists, genres: genres)
    }
}
