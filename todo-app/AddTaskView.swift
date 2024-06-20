import SwiftUI

struct AddTaskView: View {
    @State private var taskInput: ContentView.TaskInput
    @State private var showingAlert: Bool = false
    var addTask: (ContentView.Task) -> Void

    init(addTask: @escaping (ContentView.Task) -> Void, taskInput: Binding<ContentView.TaskInput>) {
        self.addTask = addTask
        self._taskInput = State(initialValue: taskInput.wrappedValue)
    }

    var body: some View {
        VStack {
            TextField("Task Name", text: $taskInput.name, axis: .vertical)
                .background(Color.blue)
                .foregroundColor(.white)
                .padding()
            
            TextField("Task Description", text: $taskInput.description, axis: .vertical)
                .padding(.horizontal)
                .background(Color.blue)
                .foregroundColor(.white)
            
            DatePicker("Deadline", selection: $taskInput.deadline, displayedComponents: .date)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
            
            Picker("Priority", selection: $taskInput.priority) {
                Text("Low").tag("Low")
                Text("High").tag("High")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            
            Button(action: {
                if !taskInput.name.isEmpty {
                    let task = ContentView.Task(name: taskInput.name, description: taskInput.description, isCompleted: taskInput.isCompleted, deadline: taskInput.deadline, priority: taskInput.priority)
                    addTask(task)
                } else {
                    showingAlert = true
                }
            }) {
                Text("Add Task")
                    .padding(10)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Task name cannot be empty"), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
    }
}
