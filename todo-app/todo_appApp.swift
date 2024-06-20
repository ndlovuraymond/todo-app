//
//  todo_appApp.swift
//  todo-app
//
//  Created by Raymond Ndlovu on 01/04/2024.
//

import SwiftUI

@main
struct todo_appApp: App {
    
    @StateObject var taskData = TaskData()
    
    var body: some Scene {
        WindowGroup {
            ParentView()
                .environmentObject(taskData)
        }
    }
}
