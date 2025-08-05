import SwiftUI
import MediaPlayer

struct AlbumListItem: View {
    @State var album : MPMediaItemCollection
    
    var totalPlayCount: Int {
            album.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        HStack{
            if let artworkImage = album.representativeItem?.artwork?.image(at: CGSize(width: 44, height: 44)) {
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
                HStack{
                    Text(album.representativeItem?.albumTitle ?? "Unknown Title" )
                        .font(.subheadline)
                    Text("-")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(album.representativeItem?.albumArtist ?? "Unknown Artist")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("\(totalPlayCount) total plays")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
