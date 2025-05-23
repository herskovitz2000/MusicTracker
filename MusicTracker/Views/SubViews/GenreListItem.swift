import SwiftUI
import MediaPlayer

struct GenreListItem: View {
    @State var genre : MPMediaItemCollection
    
    var body: some View {
        HStack{
            VStack{
                Text(genre.representativeItem?.genre ?? "Unknown Genre" )
                    .font(.system(size: 12))
                //Text(genre.representativeItem?.artist ?? "Unknown Artist")
                //    .font(.system(size: 8))
                //    .foregroundColor(.secondary)
            }
        }
    }
}
