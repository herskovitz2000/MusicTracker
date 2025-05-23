import SwiftUI
import MediaPlayer

struct AlbumListItem: View {
    @State var album : MPMediaItemCollection
    
    var body: some View {
        HStack{
            VStack{
                Text(album.representativeItem?.albumTitle ?? "Unknown Title" )
                    .font(.system(size: 12))
                Text(album.representativeItem?.albumArtist ?? "Unknown Artist")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
        }
    }
}
