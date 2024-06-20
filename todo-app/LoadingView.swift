import SwiftUI

struct LoadingView: View {
    @State private var isActive = false
    @Binding var user: User?

    var body: some View {
        if isActive {
            SignInView(user: $user)
        } else {
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                Text("Task Manager")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                ActivityIndicator()
                    .frame(width: 50, height: 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

// ActivityIndicator view for loading spinner
struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(user: .constant(nil))
    }
}

