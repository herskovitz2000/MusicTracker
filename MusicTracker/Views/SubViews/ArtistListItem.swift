import SwiftUI
import MediaPlayer

struct ArtistListItem: View {
    @State var artist : MPMediaItemCollection
    
    var body: some View {
        HStack{
            VStack{
                Text(artist.representativeItem?.artist ?? "Unknown Artist" )
                    .font(.system(size: 12))
                //Text(artist.representativeItem?.artist ?? "Unknown Artist")
                //    .font(.system(size: 8))
                //    .foregroundColor(.secondary)
            }
        }
    }
}
