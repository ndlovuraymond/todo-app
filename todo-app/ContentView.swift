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

    func fetchTasks(for userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:5000/get_tasks?user_id=\(userId)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error")
                return
            }

            do {
                let tasks = try JSONDecoder().decode([ContentView.Task].self, from: data)
                DispatchQueue.main.async {
                    self.tasks = tasks
                }
            } catch {
                print("Failed to decode response")
            }
        }.resume()
    }
}

struct ContentView: View {
    struct Task: Identifiable, Codable {
        let id: UUID
        let name: String
        let description: String
        var isCompleted: Bool
        let deadline: Date
        let priority: String

        init(id: UUID = UUID(), name: String, description: String, isCompleted: Bool, deadline: Date, priority: String) {
            self.id = id
            self.name = name
            self.description = description
            self.isCompleted = isCompleted
            self.deadline = deadline
            self.priority = priority
        }
    }

    @EnvironmentObject var taskData: TaskData
    @State private var newTask: TaskInput = TaskInput()
    @State private var userId: Int = 1 // Set this to the actual user ID

    struct TaskInput {
        var name: String = ""
        var description: String = ""
        var isCompleted: Bool = false
        var deadline: Date = Date()
        var priority: String = "Low"
    }
        
    var body: some View {
        let pendingTasks = taskData.tasks.filter { !$0.isCompleted }

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
                        Text("Completed Tasks")
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
        .onAppear {
            taskData.fetchTasks(for: userId)
        }
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
    }
}

