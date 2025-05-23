import SwiftUI
import MediaPlayer

struct PlaylistListItem: View {
    @State var playlist : MPMediaPlaylist
    
    var body: some View {
        HStack{
            VStack{
                Text(playlist.name ?? "Unknown Playlist Name" )
                    .font(.system(size: 12))
                //Text(playlist.representativeItem?.artist ?? "Unknown Artist")
                //    .font(.system(size: 8))
                //    .foregroundColor(.secondary)
            }
        }
    }
}
