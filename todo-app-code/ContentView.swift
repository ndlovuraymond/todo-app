import SwiftUI

struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    struct Task: Identifiable {
        let id = UUID()
        let name: String
        let description: String
        var isCompleted: Bool
    }
    
    @State private var tasks: [Task] = []
    @State private var newTask: TaskInput = TaskInput()

    struct TaskInput {
        var name: String = ""
        var description: String = ""
        var isCompleted: Bool = false
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Task Manager")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black)

                if tasks.isEmpty {
                    GeometryReader { geometry in
                        if geometry.size.height < 600 {
                            EmptyStatePortraitView()
                        } else {
                            Text("No tasks yet!")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                } else {
                    List {
                        Section(header: Text("Pending Tasks").foregroundColor(.black)) {
                            ForEach(tasks.filter { !$0.isCompleted }) { task in
                                NavigationLink(
                                    destination: TaskDetailView(task: task),
                                    label: {
                                        TaskRow(task: task, onDelete: {
                                            removeTask(task)
                                        }, onToggleCompletion: {
                                            toggleTaskCompletion(task)
                                        })
                                    }
                                )
                            }
                        }

                        Section(header: Text("Completed Tasks").foregroundColor(.black)) {
                            ForEach(tasks.filter { $0.isCompleted }) { task in
                                NavigationLink(
                                    destination: TaskDetailView(task: task),
                                    label: {
                                        TaskRow(task: task, onDelete: {
                                            removeTask(task)
                                        }, onToggleCompletion: {
                                            toggleTaskCompletion(task)
                                        })
                                    }
                                )
                            }
                        }
                    }
                    .listStyle(DefaultListStyle())
                    .background(Color.black)
                    .foregroundColor(.black)
                }

                HStack {
                    Spacer()
                    NavigationLink(
                        destination: AddTaskView(addTask: { task in
                            tasks.append(task)
                        }, taskInput: $newTask),
                        label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    )
                    .padding()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle for iOS-like navigation
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }

    private func removeTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}

// MARK: - EmptyStatePortraitView

struct EmptyStatePortraitView: View {
    var body: some View {
        VStack {
            Image(systemName: "note.text")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.black)

            Text("No tasks yet!")
                .font(.title)
                .foregroundColor(.black)
                .padding()

            Text("Tap the '+' button to add a new task.")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding()
                .multilineTextAlignment(.center)

            Spacer()
        }
        .background(Color.black)
        .foregroundColor(.black)
    }
}

// MARK: - AddTaskView

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
            TextField("Task Name", text: $taskInput.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Task Description", text: $taskInput.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Toggle("Completed", isOn: $taskInput.isCompleted)
                .padding()

            Button(action: {
                if !taskInput.name.isEmpty {
                    let task = ContentView.Task(name: taskInput.name, description: taskInput.description, isCompleted: taskInput.isCompleted)
                    addTask(task)
                } else {
                    showingAlert = true
                }
            }) {
                Text("Add Task")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Task name cannot be empty"), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.black)
    }
}

// MARK: - TaskRow

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
            }

            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }

            Spacer()

            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
            }
            .foregroundColor(.black)
        }
        .padding()
        .foregroundColor(.black)
    }
}

// MARK: - TaskDetailView

struct TaskDetailView: View {
    let task: ContentView.Task

    var body: some View {
        VStack {
            Text("Task Detail")
                .font(.title)
                .foregroundColor(.black)
                .padding()

            Text("Name: \(task.name)")
                .foregroundColor(.black)
                .padding()

            Text("Description: \(task.description)")
                .foregroundColor(.black)
                .padding()

            Spacer()
        }
        .background(Color.white)
        .navigationBarTitle("Task Detail", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            // Navigate back to the task list
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        })
    }
}

