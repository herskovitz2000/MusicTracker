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
    
    @State var showAllSongs : Bool = false
    @State var showAllAlbums : Bool = false
    @State var showAllArtists : Bool = false
    @State var showAllPlaylists : Bool = false
    @State var showAllGenres : Bool = false
    
    var isLibraryEmpty: Bool {
        topSongs.isEmpty &&
        topAlbums.isEmpty &&
        topArtists.isEmpty &&
        topPlaylists.isEmpty &&
        topGenres.isEmpty
    }
    
    var body: some View {
        ZStack{
            VStack {
                if isAuthorized {
                    ScrollView
                    {
                        if isLibraryEmpty {
                            if(isLoading)
                            {
                                ProgressView()
                                Text(loadingMessage)
                            }
                            else
                            {
                                VStack(spacing: 12) {
                                    Text("No music found in your library.")
                                        .font(.headline)
                                    Button(action: {
                                        getMedia()
                                    }) {
                                        Text("Refresh")
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.top, 40)
                            }
                        } else {
                            Group {
                                Image(systemName: "music.note")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                                Text("Welcome To Music Tracker!")

                                Text("Total Time Listening to Music:")
                                Text("\(hours) hours, \(minutes) minutes, \(seconds) seconds")
                                    .padding(.bottom)
                                
                                if isSongsLoading {
                                    Text("Top Songs")
                                    ProgressView("Loading Songs...")
                                } else {
                                    ZStack{
                                        Text("Top Songs")
                                        HStack{
                                            Spacer()
                                            Button("See All") {
                                                showAllSongs = true
                                            }
                                        }
                                    }
                                    TopSongs(topSongs: topSongs)
                                }

                                if isAlbumsLoading {
                                    Text("Top Albums")
                                    ProgressView("Loading Albums...")
                                } else {
                                    ZStack{
                                        Text("Top Albums")
                                        HStack{
                                            Spacer()
                                            Button("See All") {
                                                showAllAlbums = true
                                            }
                                        }
                                    }
                                    TopAlbums(topAlbums: topAlbums)
                                }

                                if isArtistsLoading {
                                    Text("Top Artists")
                                    ProgressView("Loading Artists...")
                                } else {
                                    ZStack{
                                        Text("Top Artists")
                                        HStack{
                                            Spacer()
                                            Button("See All") {
                                                showAllArtists = true
                                            }
                                        }
                                    }
                                    TopArtists(topArtists: topArtists)
                                }

                                if isPlaylistsLoading {
                                    Text("Top Playlists")
                                    ProgressView("Loading Playlists...")
                                } else {
                                    ZStack{
                                        Text("Top Playlists")
                                        HStack{
                                            Spacer()
                                            Button("See All") {
                                                showAllPlaylists = true
                                            }
                                        }
                                    }
                                    TopPlaylists(topPlaylists: topPlaylists)
                                }

                                if isGenresLoading {
                                    Text("Top Genres")
                                    ProgressView("Loading Genres...")
                                } else {
                                    ZStack{
                                        Text("Top Genres")
                                        HStack{
                                            Spacer()
                                            Button("See All") {
                                                showAllGenres = true
                                            }
                                        }
                                    }
                                    TopGenres(topGenres: topGenres)
                                }
                            }
                        }
                    }
                    .refreshable {
                        getMedia()
                    }
                } else {
                    Text("Please authorize access to your music library.")
                    Button("Open Settings") {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }
                }
            }
            
            if(showAllSongs)
            {
                Songs(topSongs: topSongs, showAllSongs: $showAllSongs)
            }
            else if(showAllAlbums)
            {
                Albums(topAlbums: topAlbums, showAllAlbums: $showAllAlbums)
            }
            else if (showAllArtists)
            {
                Artists(topArtists: topArtists, showAllArtists: $showAllArtists)
            }
            else if (showAllPlaylists)
            {
                Playlists(topPlaylists: topPlaylists, showAllPlaylists: $showAllPlaylists)
            }
            else if (showAllGenres)
            {
                Genres(topGenres: topGenres, showAllGenres: $showAllGenres)
            }
        }
        .padding()
        .onAppear {
            OnAppear()
        }
    }

    func OnAppear() {
        isLoading = true
        
        // Check current authorization status
        let status = MPMediaLibrary.authorizationStatus()
        handleAuthorizationStatus(status)
    }
    
    func handleAuthorizationStatus(_ status: MPMediaLibraryAuthorizationStatus) {
        switch status {
        case .authorized:
            // User already authorized, proceed to get media
            isAuthorized = true
            getMedia()
        case .notDetermined:
            // User has not yet decided, request authorization
            requestAuthorization()
        case .denied, .restricted:
            // Access denied or restricted, handle accordingly
            isAuthorized = false
            isLoading = false // Stop loading if access is denied
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func requestAuthorization() {
        // Request authorization asynchronously
        isLoading = true
        loadingMessage = "Requesting Access..."
        
        MPMediaLibrary.requestAuthorization { status in
            // Update UI on the main thread after the request is complete
            DispatchQueue.main.async {
                handleAuthorizationStatus(status)
                //isLoading = false // Stop loading once the authorization is finished
            }
        }
    }

    func getMedia() {
        // Reset loading flags and state
        isLoading = true
        isSongsLoading = true
        isAlbumsLoading = true
        isArtistsLoading = true
        isPlaylistsLoading = true
        isGenresLoading = true

        func checkIfAllDone() {
            if !isSongsLoading && !isAlbumsLoading && !isArtistsLoading && !isPlaylistsLoading && !isGenresLoading {
                isLoading = false
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let songsQuery = MPMediaQuery.songs()
            let albumsQuery = MPMediaQuery.albums()
            let artistsQuery = MPMediaQuery.artists()
            let playlistsQuery = MPMediaQuery.playlists()
            let genresQuery = MPMediaQuery.genres()

            // Songs
            if let songs = songsQuery.items {
                let totalSecondsLocal = songs.reduce(0) { $0 + ($1.playbackDuration * Double($1.playCount)) }
                let h = Int(totalSecondsLocal / 3600)
                let m = Int(Int(totalSecondsLocal) % 3600 / 60)
                let s = Int(totalSecondsLocal) % 60

                let sortedSongs = songs.sorted { $0.playCount > $1.playCount }

                DispatchQueue.main.async {
                    self.totalSeconds = totalSecondsLocal
                    self.hours = h
                    self.minutes = m
                    self.seconds = s
                    self.topSongs = sortedSongs
                    self.isSongsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.isSongsLoading = false
                    checkIfAllDone()
                }
            }

            // Albums
            if let albums = albumsQuery.collections {
                let sortedAlbums = albums.sorted {
                    $0.items.reduce(0) { $0 + $1.playCount } > $1.items.reduce(0) { $0 + $1.playCount }
                }
                DispatchQueue.main.async {
                    self.topAlbums = sortedAlbums
                    self.isAlbumsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.isAlbumsLoading = false
                    checkIfAllDone()
                }
            }

            // Artists
            if let artists = artistsQuery.collections {
                let sortedArtists = artists.sorted {
                    $0.items.reduce(0) { $0 + $1.playCount } > $1.items.reduce(0) { $0 + $1.playCount }
                }
                DispatchQueue.main.async {
                    self.topArtists = sortedArtists
                    self.isArtistsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.isArtistsLoading = false
                    checkIfAllDone()
                }
            }

            // Playlists
            if let playlists = playlistsQuery.collections as? [MPMediaPlaylist] {
                let sortedPlaylists = playlists.sorted {
                    $0.items.reduce(0) { $0 + $1.playCount } > $1.items.reduce(0) { $0 + $1.playCount }
                }
                DispatchQueue.main.async {
                    self.topPlaylists = sortedPlaylists
                    self.isPlaylistsLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.isPlaylistsLoading = false
                    checkIfAllDone()
                }
            }

            // Genres
            if let genres = genresQuery.collections {
                let sortedGenres = genres.sorted {
                    $0.items.reduce(0) { $0 + $1.playCount } > $1.items.reduce(0) { $0 + $1.playCount }
                }
                DispatchQueue.main.async {
                    self.topGenres = sortedGenres
                    self.isGenresLoading = false
                    checkIfAllDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.isGenresLoading = false
                    checkIfAllDone()
                }
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
