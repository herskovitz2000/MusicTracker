import SwiftUI
import MediaPlayer

struct LandingPage: View {
    
    @State var isLoading : Bool = false
    @State var loadingMessage : String = ""
    
    @State var isSongsLoading : Bool = false
    @State var isAlbumsLoading : Bool = false
    @State var isArtistsLoading : Bool = false
    @State var isPlaylistsLoading : Bool = false
    @State var isGenresLoading : Bool = false
    
    @State var isAuthorized : Bool = false
    
    @State var totalSeconds : TimeInterval = 0
    @State var hours : Int = 0
    @State var minutes : Int = 0
    @State var seconds : Int = 0
    
    @State var topSongs : [MPMediaItem] = []
    @State var topAlbums : [MPMediaItemCollection] = []
    @State var topArtists : [MPMediaItemCollection] = []
    @State var topPlaylists : [MPMediaPlaylist] = []
    @State var topGenres : [MPMediaItemCollection] = []
    

    
    var isLibraryEmpty: Bool {
        topSongs.isEmpty &&
        topAlbums.isEmpty &&
        topArtists.isEmpty &&
        topPlaylists.isEmpty &&
        topGenres.isEmpty
    }
    
    private func getTotalPlayCount(from collection: MPMediaItemCollection) -> Int {
        let uniqueItems = Dictionary(grouping: collection.items) { $0.persistentID }
            .compactMapValues { $0.first }
            .values
        return uniqueItems.reduce(0) { $0 + $1.playCount }
    }
    
    private func getUniqueSongs(from songs: [MPMediaItem]) -> [MPMediaItem] {
        let uniqueSongs = Dictionary(grouping: songs) { $0.persistentID }
            .compactMapValues { $0.first }
            .values
        return Array(uniqueSongs)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isAuthorized {
                    if isLibraryEmpty {
                        emptyLibraryView
                    } else {
                        libraryContentView
                    }
                } else {
                    unauthorizedView
                }
            }
            .navigationDestination(for: MusicRoute.self) { route in
                switch route {
                case .allSongs:
                    Songs(topSongs: topSongs)
                case .allAlbums:
                    Albums(topAlbums: topAlbums)
                case .allArtists:
                    Artists(topArtists: topArtists)
                case .allPlaylists:
                    Playlists(topPlaylists: topPlaylists)
                case .allGenres:
                    Genres(topGenres: topGenres)
                case .songDetail(let song):
                    Song(Song: song)
                case .albumDetail(let album):
                    Album(Album: album)
                case .artistDetail(let artist):
                    Artist(Artist: artist)
                case .playlistDetail(let playlist):
                    Playlist(Playlist: playlist)
                case .genreDetail(let genre):
                    Genre(Genre: genre)
                }
            }
        }
        .onAppear {
            OnAppear()
        }
    }
    
    var emptyLibraryView: some View {
        VStack(spacing: 12) {
            if isLoading {
                ProgressView()
                Text(loadingMessage)
            } else {
                Text("No music found in your library.")
                    .font(.headline)
                Button("Refresh") {
                    getMedia()
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
        }
        .padding(.top, 40)
    }
    
    var libraryContentView: some View {
        List {
            // Header
            // Header
            Section {
                VStack(spacing: 24) {
                    Image(systemName: "music.quarternote.3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.top, 10)
                    
                    VStack(spacing: 8) {
                        Text("Welcome to")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text("Music Tracker")
                            .font(.largeTitle.weight(.black))
                            .foregroundStyle(.primary)
                    }
                    .multilineTextAlignment(.center)
                    
                    VStack(spacing: 8) {
                        Text("Total Time Listening")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        
                        Text("\(hours)h \(minutes)m \(seconds)s")
                            .font(.system(.title3, design: .rounded).monospacedDigit())
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .listRowBackground(Color.clear)
            }
            
            // Top Songs
            Section {
                sectionHeader(title: "Top Songs", route: .allSongs)
                if isSongsLoading {
                    ProgressView("Loading Songs...")
                } else {
                    ForEach(Array(topSongs.prefix(3).enumerated()), id: \.element.persistentID) { index, song in
                        NavigationLink(value: MusicRoute.songDetail(song)) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                SongListItem(song: song)
                            }
                        }
                    }
                }
            }
            
            // Top Albums
            Section {
                sectionHeader(title: "Top Albums", route: .allAlbums)
                if isAlbumsLoading {
                    ProgressView("Loading Albums...")
                } else {
                    // Assuming TopAlbums view logic needs to be replicated or replaced
                    // For now, let's replicate the list style
                     ForEach(Array(topAlbums.prefix(3).enumerated()), id: \.element.persistentID) { index, album in
                        NavigationLink(value: MusicRoute.albumDetail(album)) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                AlbumListItem(album: album)
                            }
                        }
                    }
                }
            }
            
            // Top Artists
            Section {
                sectionHeader(title: "Top Artists", route: .allArtists)
                if isArtistsLoading {
                    ProgressView("Loading Artists...")
                } else {
                     ForEach(Array(topArtists.prefix(3).enumerated()), id: \.element.persistentID) { index, artist in
                        NavigationLink(value: MusicRoute.artistDetail(artist)) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                ArtistListItem(artist: artist)
                            }
                        }
                    }
                }
            }
            
            // Top Playlists
            Section {
                sectionHeader(title: "Top Playlists", route: .allPlaylists)
                if isPlaylistsLoading {
                    ProgressView("Loading Playlists...")
                } else {
                     ForEach(Array(topPlaylists.prefix(3).enumerated()), id: \.element.persistentID) { index, playlist in
                        NavigationLink(value: MusicRoute.playlistDetail(playlist)) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                PlaylistListItem(playlist: playlist)
                            }
                        }
                    }
                }
            }
            
            // Top Genres
            Section {
                sectionHeader(title: "Top Genres", route: .allGenres)
                if isGenresLoading {
                    ProgressView("Loading Genres...")
                } else {
                    ForEach(Array(topGenres.prefix(3).enumerated()), id: \.element.persistentID) { index, genre in
                        NavigationLink(value: MusicRoute.genreDetail(genre)) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                GenreListItem(genre: genre)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            getMedia()
        }
    }
    
    var unauthorizedView: some View {
        VStack {
            Text("Please authorize access to your music library.")
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }
    }
    
    @ViewBuilder
    private func sectionHeader(title: String, route: MusicRoute) -> some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            NavigationLink("See All", value: route)
                .foregroundColor(.blue)
        }
    }
    
    func OnAppear() {
        // Prevent re-fetching if already loading or if we already have data
        guard !isLoading else { return }
        
        // If we already have content, don't re-run authorization check/fetch
        if !isLibraryEmpty { return }

        let status = MPMediaLibrary.authorizationStatus()
        handleAuthorizationStatus(status)
    }
    
    func handleAuthorizationStatus(_ status: MPMediaLibraryAuthorizationStatus) {
        switch status {
        case .authorized:
            isAuthorized = true
            Task {
                // Only try to load cache if we don't have data
                if isLibraryEmpty {
                    let loaded = await loadCachedData()
                    if !loaded {
                        isLoading = false
                        getMedia()
                    }
                }
            }
        case .notDetermined:
            requestAuthorization()
        case .denied, .restricted:
            isAuthorized = false
            isLoading = false
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func requestAuthorization() {
        isLoading = true
        loadingMessage = "Requesting Access..."
        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                handleAuthorizationStatus(status)
            }
        }
    }
    
    func getMedia() {
        // Double check strict guard
        guard !isLoading else { return }
        
        isLoading = true
        loadingMessage = "Loading Library..."
        isSongsLoading = true
        isAlbumsLoading = true
        isArtistsLoading = true
        isPlaylistsLoading = true
        isGenresLoading = true
        
        func checkIfAllDone() {
            if !isSongsLoading && !isAlbumsLoading && !isArtistsLoading && !isPlaylistsLoading && !isGenresLoading {
                isLoading = false
                cacheData()
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = Date()
            
            let songsStart = Date()
            let songsQuery = MPMediaQuery.songs()
            if let songs = songsQuery.items {
                let uniqueSongs = getUniqueSongs(from: songs)
                let totalSecondsLocal = uniqueSongs.reduce(0) { $0 + ($1.playbackDuration * Double($1.playCount)) }
                let h = Int(totalSecondsLocal / 3600)
                let m = (Int(totalSecondsLocal) % 3600) / 60
                let s = Int(totalSecondsLocal) % 60
                let sortedSongs = uniqueSongs.sorted { $0.playCount > $1.playCount }
                print("Main: Loaded \(sortedSongs.count) Songs in \(Date().timeIntervalSince(songsStart))s")
                DispatchQueue.main.async {
                    totalSeconds = totalSecondsLocal
                    hours = h
                    minutes = m
                    seconds = s
                    topSongs = sortedSongs
                    isSongsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    isSongsLoading = false
                    checkIfAllDone()
                }
            }
            
            let albumsStart = Date()
            let albumsQuery = MPMediaQuery.albums()
            if let albums = albumsQuery.collections {
                let sortedAlbums = albums.sorted {
                    getTotalPlayCount(from: $0) > getTotalPlayCount(from: $1)
                }
                print("Main: Loaded \(sortedAlbums.count) Albums in \(Date().timeIntervalSince(albumsStart))s")
                DispatchQueue.main.async {
                    topAlbums = sortedAlbums
                    isAlbumsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    isAlbumsLoading = false
                    checkIfAllDone()
                }
            }
            
            let artistsStart = Date()
            let artistsQuery = MPMediaQuery.artists()
            if let artists = artistsQuery.collections {
                let sortedArtists = artists.sorted {
                    getTotalPlayCount(from: $0) > getTotalPlayCount(from: $1)
                }
                print("Main: Loaded \(sortedArtists.count) Artists in \(Date().timeIntervalSince(artistsStart))s")
                DispatchQueue.main.async {
                    topArtists = sortedArtists
                    isArtistsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    isArtistsLoading = false
                    checkIfAllDone()
                }
            }
            
            let playlistsStart = Date()
            let playlistsQuery = MPMediaQuery.playlists()
            if let playlists = playlistsQuery.collections as? [MPMediaPlaylist] {
                let sortedPlaylists = playlists.sorted {
                    getTotalPlayCount(from: $0) > getTotalPlayCount(from: $1)
                }
                print("Main: Loaded \(sortedPlaylists.count) Playlists in \(Date().timeIntervalSince(playlistsStart))s")
                DispatchQueue.main.async {
                    topPlaylists = sortedPlaylists
                    isPlaylistsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    isPlaylistsLoading = false
                    checkIfAllDone()
                }
            }
            
            let genresStart = Date()
            let genresQuery = MPMediaQuery.genres()
            if let genres = genresQuery.collections {
                let sortedGenres = genres.sorted {
                    getTotalPlayCount(from: $0) > getTotalPlayCount(from: $1)
                }
                print("Main: Loaded \(sortedGenres.count) Genres in \(Date().timeIntervalSince(genresStart))s")
                DispatchQueue.main.async {
                    topGenres = sortedGenres
                    isGenresLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    isGenresLoading = false
                    checkIfAllDone()
                }
            }
            print("Main: Total Fetched Time: \(Date().timeIntervalSince(startTime))s")
        }
    }
    
    func loadCachedData() async -> Bool {
        let loadStart = Date()
        guard let cache = await MusicCacheManager.loadCache() else { return false }
        print("Main: Loaded Cache File in \(Date().timeIntervalSince(loadStart))s")
        
        // Process data in background
        let convertStart = Date()
        let convertedData = await Task.detached(priority: .userInitiated) {
            return MusicCacheManager.convertCacheToMediaObjects(cache: cache)
        }.value
        print("Main: Converted Cache to Objects in \(Date().timeIntervalSince(convertStart))s")
        
        // Update UI on MainActor
        await MainActor.run {
            topSongs = convertedData.songs
            topAlbums = convertedData.albums
            topArtists = convertedData.artists
            topPlaylists = convertedData.playlists
            topGenres = convertedData.genres
            totalSeconds = cache.totalSeconds
            let h = Int(cache.totalSeconds / 3600)
            let m = (Int(cache.totalSeconds) % 3600) / 60
            let s = Int(cache.totalSeconds) % 60
            hours = h
            minutes = m
            seconds = s
            isSongsLoading = false
            isAlbumsLoading = false
            isArtistsLoading = false
            isPlaylistsLoading = false
            isGenresLoading = false
            isLoading = false
        }
        return true
    }
    
    func cacheData() {
        Task { @MainActor in
            // Build cache in batches to avoid freezing UI
            let songs = await batchMap(topSongs) { CachedSong(from: $0) }
            let albums = await batchMap(topAlbums) { CachedAlbum(from: $0) }
            let artists = await batchMap(topArtists) { CachedArtist(from: $0) }
            let playlists = await batchMap(topPlaylists) { CachedPlaylist(from: $0) }
            let genres = await batchMap(topGenres) { CachedGenre(from: $0) }
            
            let cache = MusicCache(
                cachedSongs: songs,
                cachedAlbums: albums,
                cachedArtists: artists,
                cachedPlaylists: playlists,
                cachedGenres: genres,
                totalSeconds: totalSeconds
            )
            
            await MusicCacheManager.saveCache(cache: cache)
        }
    }
    
    // Helper to map large arrays in chunks, yielding to main runloop
    private func batchMap<T, U>(_ items: [T], transform: (T) -> U) async -> [U] {
        var results: [U] = []
        results.reserveCapacity(items.count)
        
        let batchSize = 30 // Smaller batch size prevents frames from dropping
        for chunk in items.chunked(into: batchSize) {
            for item in chunk {
                results.append(transform(item))
            }
            // Explicit sleep guarantees the runloop gets a turn to render
            try? await Task.sleep(nanoseconds: 2_000_000) // 2ms 
        }
        return results
    }

}

enum MusicRoute: Hashable {
    case allSongs
    case allAlbums
    case allArtists
    case allPlaylists
    case allGenres
    case songDetail(MPMediaItem)
    case albumDetail(MPMediaItemCollection)
    case artistDetail(MPMediaItemCollection)
    case playlistDetail(MPMediaPlaylist)
    case genreDetail(MPMediaItemCollection)
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
