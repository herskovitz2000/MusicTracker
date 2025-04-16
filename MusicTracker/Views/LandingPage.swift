import SwiftUI
import MediaPlayer

struct LandingPage: View {
    
    @State var isLoading : Bool = false
    @State var loadingMessage : String = ""
    
    @State var isAuthorized : Bool = false
    
    
    
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
                    Image(systemName: "music.note")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Welcome To Music Tracker!")
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
            let query = MPMediaQuery.songs()
            
            if let items = query.items {
                for song in items {
                    let title = song.title ?? "Unknown Title"
                    let playCount = song.playCount
                    let artist = song.artist ?? "Unknown artist"
                    print("Title: \(title), Artist: \(artist), Play Count: \(playCount), Length: \(song.playbackDuration)")
                }
            } else {
                print("no songs found in the library")
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
