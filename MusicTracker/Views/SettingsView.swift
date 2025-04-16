import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings View")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding()
            // Add additional settings UI elements here as needed
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
