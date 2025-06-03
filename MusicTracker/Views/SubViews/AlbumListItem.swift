import SwiftUI
import MediaPlayer

struct AlbumListItem: View {
    @State var album : MPMediaItemCollection
    
    var totalPlayCount: Int {
            album.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(album.representativeItem?.albumTitle ?? "Unknown Title" )
                    .font(.system(size: 12))
                Text("-")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
                Text(album.representativeItem?.albumArtist ?? "Unknown Artist")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
            Text("\(totalPlayCount) total plays")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
        }
    }
}
