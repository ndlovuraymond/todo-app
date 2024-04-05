import SwiftUI

struct TaskDetailView: View {
    let task: ContentView.Task

    var body: some View {
        VStack {
            Text("Name: \(task.name)")
                .foregroundColor(.black)
                .padding()

            Text("Description: \(task.description)")
                .foregroundColor(.black)
                .padding()

            Spacer()
        }
        .background(Color.blue)
        .navigationBarTitle("Task Detail", displayMode: .inline)
        .navigationBarBackButtonHidden(false)
    }
}

