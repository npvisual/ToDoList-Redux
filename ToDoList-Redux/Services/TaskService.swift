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
}
