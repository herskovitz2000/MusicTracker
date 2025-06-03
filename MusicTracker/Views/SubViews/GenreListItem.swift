import SwiftUI
import MediaPlayer

struct GenreListItem: View {
    @State var genre : MPMediaItemCollection
    
    var totalPlayCount: Int {
            genre.items.reduce(0) { $0 + $1.playCount }
    }
    
    var body: some View {
        HStack{
            VStack{
                Text(genre.representativeItem?.genre ?? "Unknown Genre" )
                    .font(.system(size: 12))
                //Text(genre.representativeItem?.artist ?? "Unknown Artist")
                //    .font(.system(size: 8))
                //    .foregroundColor(.secondary)
                Text("\(totalPlayCount) total plays")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
        }
    }
}
