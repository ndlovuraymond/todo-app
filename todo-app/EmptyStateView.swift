import SwiftUI

struct EmptyStatePortraitView: View {
    var body: some View {
        HStack {
            Image(systemName: "note.text")
                .foregroundColor(.white)
                .imageScale(.large)

            Text("Tap the '+' button to add a new task.")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .multilineTextAlignment(.center)

            Spacer()
        }
        .background(Color.blue)
        .foregroundColor(.white)
        .padding()
    }
}

