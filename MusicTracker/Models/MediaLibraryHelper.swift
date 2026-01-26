import Foundation
import MediaPlayer

class MediaLibraryHelper {
    
    static func getAlbum(by persistentID: UInt64) -> MPMediaItemCollection? {
        let query = MPMediaQuery.albums()
        let predicate = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyAlbumPersistentID)
        query.addFilterPredicate(predicate)
        return query.collections?.first
    }
    
    static func getArtist(by persistentID: UInt64) -> MPMediaItemCollection? {
        let query = MPMediaQuery.artists()
        let predicate = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyArtistPersistentID)
        query.addFilterPredicate(predicate)
        return query.collections?.first
    }
    
    static func getGenre(by persistentID: UInt64) -> MPMediaItemCollection? {
        let query = MPMediaQuery.genres()
        let predicate = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyGenrePersistentID)
        query.addFilterPredicate(predicate)
        return query.collections?.first
    }
    
    static func getSongs(forAlbum albumID: UInt64) -> [MPMediaItem] {
        let query = MPMediaQuery.songs()
        let predicate = MPMediaPropertyPredicate(value: albumID, forProperty: MPMediaItemPropertyAlbumPersistentID)
        query.addFilterPredicate(predicate)
        return query.items ?? []
    }
    
    static func getAlbums(forArtist artistID: UInt64) -> [MPMediaItemCollection] {
        let query = MPMediaQuery.albums()
        let predicate = MPMediaPropertyPredicate(value: artistID, forProperty: MPMediaItemPropertyArtistPersistentID)
        query.addFilterPredicate(predicate)
        return query.collections ?? []
    }
    
    static func getAlbums(forGenre genreID: UInt64) -> [MPMediaItemCollection] {
        let query = MPMediaQuery.albums()
        let predicate = MPMediaPropertyPredicate(value: genreID, forProperty: MPMediaItemPropertyGenrePersistentID)
        query.addFilterPredicate(predicate)
        return query.collections ?? []
    }
}
