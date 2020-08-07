//
//  TaskView.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/4/20.
//

import Foundation

import SwiftRex


// MARK: - STATE

struct TaskState: Equatable {
    var title: String
    var tasks: [Task]
    
    static var empty: TaskState {
        .init(title: "Tasks", tasks: [])
    }
    
    static var mock: TaskState {
        .init(title: "Tasks", tasks: [
            Task(title: "Implement UI", priority: .medium, completed: true),
            Task(title: "Connect to Firebase", priority: .medium, completed: false),
            Task(title: "????", priority: .high, completed: false),
            Task(title: "PROFIT!!!", priority: .high, completed: false)
        ]
        )
    }
}


// MARK: - ACTIONS

enum TaskAction {
    case add(String)
    case remove(IndexSet)
    case move(IndexSet, Int)
    case toggle(String)
}


// MARK: - REDUCERS

extension Reducer where ActionType == TaskAction, StateType == TaskState {
    static let task = Reducer { action, state in
        var state = state
        switch action {
            case let .add(title):
                state.tasks.append(Task(title: title, priority: .medium, completed: false))
            case let .remove(offset):
                state.tasks.remove(atOffsets: offset)
            case let .move(offset, index):
                state.tasks.move(fromOffsets: offset, toOffset: index)
            case let .toggle(id):
                if let index = state.tasks.firstIndex(where: {$0.id == id}) {
                    state.tasks[index].completed.toggle()
                }
        }
        return state
    }
}
