import SwiftUI

struct SignInView: View {
    @Binding var user: User?
    @State private var username: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                        Text("Task Manager")
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.white)
                    }

                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                    Button(action: {
                        verifyUser(username: username)
                    }) {
                        Text("Sign In")
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding()

                    NavigationLink(destination: SignUpView(user: $user), label: {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(8)
                    })
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Sign In Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }

    func verifyUser(username: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/verify_user") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["username": username]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.alertMessage = "Network error"
                    self.showAlert = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                DispatchQueue.main.async {
                    self.alertMessage = "User not found"
                    self.showAlert = true
                }
                return
            }
            
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let status = responseDict?["status"] as? String, status == "success",
                   let userData = responseDict?["user"] as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: userData),
                   let decodedUser = try? JSONDecoder().decode(User.self, from: jsonData) {
                    DispatchQueue.main.async {
                        self.user = decodedUser
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Invalid response"
                        self.showAlert = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to decode response"
                    self.showAlert = true
                }
            }
        }.resume()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(user: .constant(nil))
    }
}

