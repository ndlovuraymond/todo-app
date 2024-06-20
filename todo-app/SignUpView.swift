import SwiftUI

struct SignUpView: View {
    @Binding var user: User?
    @State private var username: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Male"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showContentView = false
    
    var body: some View {
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
                
                TextField("Age", text: $age)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .keyboardType(.numberPad)
                
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(.white)
                .padding()
                .cornerRadius(8)

                Button(action: {
                    createUser()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Sign Up Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showContentView) {
            ContentView().environmentObject(TaskData())
        }
    }
    
    func createUser() {
        guard let url = URL(string: "http://127.0.0.1:5000/create_user") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["username": username, "age": age, "gender": gender]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.alertMessage = "Network error"
                    self.showAlert = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to create user"
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
                        self.showContentView = true
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(user: .constant(nil))
    }
}
