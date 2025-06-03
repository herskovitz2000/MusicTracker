import SwiftUI
import MediaPlayer

struct ArtistListItem: View {
    @State var artist : MPMediaItemCollection
    
    var totalPlayCount: Int {
            artist.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        HStack{
            VStack{
                Text(artist.representativeItem?.artist ?? "Unknown Artist" )
                    .font(.system(size: 12))
                //Text(artist.representativeItem?.artist ?? "Unknown Artist")
                //    .font(.system(size: 8))
                //    .foregroundColor(.secondary)
                Text("\(totalPlayCount) total plays")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
        }
    }
}
