import SwiftUI

struct TaskRow: View {
    let task: ContentView.Task
    var onDelete: () -> Void
    var onToggleCompletion: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onToggleCompletion()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }.buttonStyle(BorderlessButtonStyle())

            VStack(alignment: .leading) {
                Text(task.name)
            }

            Spacer()

            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}
