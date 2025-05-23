import SwiftUI
import MediaPlayer

struct LandingPage: View {
    
    @State var isLoading : Bool = false
    @State var loadingMessage : String = ""
    
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
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                Text(loadingMessage)
                    .padding()
            } else {
                if isAuthorized {
                    ScrollView{
                        Image(systemName: "music.note")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        Text("Welcome To Music Tracker!")
                        
                        Text("Total Time Listening to music:")
                        Text("\(hours) hours, \(minutes) minutes, \(seconds) seconds")
                        
                        TopSongs(topSongs: topSongs)
                        
                        TopAlbums(topAlbums: topAlbums)
                        
                        TopArtists(topArtists: topArtists)
                        
                        TopPlaylists(topPlaylists: topPlaylists)
                        
                        TopGenres(topGenres: topGenres)
                    }
                } else {
                    Image(systemName: "music.note")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Welcome To Music Tracker!")
                    Button(
                        action: {
                            if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                                       UIApplication.shared.canOpenURL(settingsUrl) {
                                        UIApplication.shared.open(settingsUrl)
                                    }
                        },
                        label: {
                            Text("Click here to give permission to access your music library!")
                        }
                    )
                }
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
        loadingMessage = "Getting Media..."
        print("getting media")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let songsQuery = MPMediaQuery.songs()
            let albumsQuery = MPMediaQuery.albums()
            let artistsQuery = MPMediaQuery.artists()
            let playlistsQuery = MPMediaQuery.playlists()
            let genresQuery = MPMediaQuery.genres()
            
            if let songs = songsQuery.items {
                totalSeconds = songs.reduce(0) { $0 + ($1.playbackDuration * Double($1.playCount)) }
                hours = Int(totalSeconds / 3600)
                let remainingSeconds = Int(totalSeconds) % 3600
                minutes = Int(remainingSeconds / 60)
                seconds = Int(remainingSeconds % 60)
                
                //may want to play around with displaying some info while sorting
                //topSongs = songs.sorted { ($0.playCount * Int(Double($0.playbackDuration))) > ($1.playCount * Int(Double($1.playbackDuration))) }
                topSongs = songs.sorted { $0.playCount > $1.playCount }
                
                /* test
                for song in songs {
                    let title = song.title ?? "Unknown Title"
                    let playCount = song.playCount
                    let artist = song.artist ?? "Unknown artist"
                    print("Title: \(title), Artist: \(artist), Play Count: \(playCount), Length: \(song.playbackDuration)")
                }
                */
            } else {
                print("no songs found in the library")
            }
            
            
            if let albums = albumsQuery.collections {
                //topAlbums = albums.sorted { $0.playCount > $1.playCount }
                topAlbums = albums.sorted {
                    let playCount0 = $0.items.reduce(0) { $0 + $1.playCount }
                        let playCount1 = $1.items.reduce(0) { $0 + $1.playCount }
                        return playCount0 > playCount1
                }
            } else {
                print("no albums found in the library")
            }
            
            if let artists = artistsQuery.collections {
                topArtists = artists.sorted {
                    let playCount0 = $0.items.reduce(0) { $0 + $1.playCount }
                    let playCount1 = $1.items.reduce(0) { $0 + $1.playCount }
                    return playCount0 > playCount1
                }
            }
            else{
                print("no artists found in the library")
            }
            
            if let playlists = playlistsQuery.collections{
                topPlaylists = playlists.sorted {
                    let playCount0 = $0.items.reduce(0) { $0 + $1.playCount }
                    let playCount1 = $1.items.reduce(0) { $0 + $1.playCount }
                    return playCount0 > playCount1
                } as? [MPMediaPlaylist] ?? []
            }
            else{
                print("no playlists found in the library")
            }
            
            if let genres = genresQuery.collections {
                topGenres = genres.sorted {
                    let playCount0 = $0.items.reduce(0) { $0 + $1.playCount }
                    let playCount1 = $1.items.reduce(0) { $0 + $1.playCount }
                    return playCount0 > playCount1
                }
            }
            else{
                print("no genres found in the library")
            }
            
            
            // Update UI on the main thread after the task is completed
            DispatchQueue.main.async {
                isLoading = false // Stop loading once the media has been fetched
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
