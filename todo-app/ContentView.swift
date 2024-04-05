import SwiftUI

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.black
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
    }
}

class TaskData: ObservableObject {
    @Published var tasks: [ContentView.Task] = []
}

//struct ToDoListApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

struct ContentView: View {
    struct Task: Identifiable {
        let id = UUID()
        let name: String
        let description: String
        var isCompleted: Bool
    }
    
    
    @State private var isActive: Bool = false
    @EnvironmentObject var taskData: TaskData
    @State private var newTask: TaskInput = TaskInput()

    struct TaskInput {
        var name: String = ""
        var description: String = ""
        var isCompleted: Bool = false
    }
    
    //private var pendingTasks: [Task] = []
    
        
    var body: some View {
        var pendingTasks = taskData.tasks.filter{ !$0.isCompleted}
        
        NavigationView {
            VStack {
                Text("Task Manager")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black)

                if taskData.tasks.isEmpty {
                    GeometryReader { geometry in
                        if geometry.size.height < 600 {
                            EmptyStatePortraitView()
                        } else {
                            Text("No tasks yet!")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                        }
                    }
                } else {
                    List {
                        Section(header: Text("Pending Tasks")
                            .foregroundColor(.white)) {
                                ForEach(pendingTasks) { task in
                                        TaskRow(task: task, onDelete: {
                                            removeTask(task)
                                        }, onToggleCompletion: {
                                            toggleTaskCompletion(task)
                                        })
                                    }
                                }
                            }
                            .listStyle(DefaultListStyle())
                            .scrollContentBackground(.hidden)
                            .background(Color.blue)
                        }

                HStack {
                    NavigationLink(destination: CompletedTasks(removeTask: removeTask,
                        toggleTaskCompletion: toggleTaskCompletion)) {
                                        Text("Complete Tasks")
                                            .foregroundColor(.blue)
                                            .padding(10)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                    }
                    Spacer()
                    NavigationLink(
                        destination: AddTaskView(addTask: { task in
                            taskData.tasks.append(task)
                        }, taskInput: $newTask),
                        label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    )
                }
                .padding()
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle for iOS-like navigation
            .navigationBarHidden(true) // Hide the navigation bar
            .background(Color.blue)
        }
        .background(Color.blue)
    }

    private func removeTask(_ task: Task) {
        if let index = taskData.tasks.firstIndex(where: { $0.id == task.id }) {
            taskData.tasks.remove(at: index)
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = taskData.tasks.firstIndex(where: { $0.id == task.id }) {
            taskData.tasks[index].isCompleted.toggle()
        }
        print(taskData.tasks.filter { $0.isCompleted })
    }
}

