//
//  TaskService.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/3/20.
//

import Foundation
import Combine

final class TaskService: ObservableObject {
    @Published var tasks: [Task] = []
    
    func orderByPriority() {
        tasks.sort { $0.priority > $1.priority }
    }
    
    func removeCompleted() {
        tasks.removeAll { $0.completed }
    }
    
    #if DEBUG
    init() {
        tasks = [
            Task(title: "Implement UI", priority: .medium, completed: true),
            Task(title: "Connect to Firebase", priority: .medium, completed: false),
            Task(title: "????", priority: .high, completed: false),
            Task(title: "PROFIT!!!", priority: .high, completed: false)
        ]
    }
    #endif
}
