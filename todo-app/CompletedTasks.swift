//
//  CompletedTasks.swift
//  todo-app
//
//  Created by Raymond Ndlovu on 05/04/2024.
//

import SwiftUI

struct CompletedTasks: View {
    @EnvironmentObject var taskData: TaskData
    var removeTask: (ContentView.Task) -> Void
    var toggleTaskCompletion: (ContentView.Task) -> Void
    
    var body: some View {
        let completedTasks = taskData.tasks.filter{ $0.isCompleted}
        NavigationView {
            VStack {
                List {
                            Section(header: Text("Completed Tasks").foregroundColor(.white)) {
                                ForEach(completedTasks) { task in
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
            .listStyle(DefaultListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.blue)
        }
        .background(Color.blue)
        .onAppear {
            print(completedTasks)
            print("------------------")
            print(taskData.tasks)
        }
    }
}
