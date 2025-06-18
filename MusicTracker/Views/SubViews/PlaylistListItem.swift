import SwiftUI
import MediaPlayer

struct PlaylistListItem: View {
    @State var playlist : MPMediaPlaylist
    
    var totalPlayCount: Int {
            playlist.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        HStack{
            
            if let artworkImage = playlist.representativeItem?.artwork?.image(at: CGSize(width: 44, height: 44)) {
                Image(uiImage: artworkImage)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .cornerRadius(4)
            } else {
                // Placeholder if there's no artwork
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .cornerRadius(4)
                    .overlay(
                        Text("No Art")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    )
            }
            
            VStack (alignment: .leading){
                Text(playlist.name ?? "Unknown Playlist Name" )
                    .font(.system(size: 12))
                //Text(playlist.representativeItem?.artist ?? "Unknown Artist")
                //    .font(.system(size: 8))
                //    .foregroundColor(.secondary)
                Text("\(totalPlayCount) total plays")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
