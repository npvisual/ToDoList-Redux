//
//  TaskService.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/3/20.
//

import Foundation
import Combine

//import SwiftRex
//
//// MARK: - Store
//#if DEBUG
//var store = Store.insta
//#else
//let store = Store(reducer: Scoreboard.reducer, initialState: TaskService.State())
//#endif
//
//enum TaskService {
//
//    // MARK: - State
//
//    struct State: Equatable {
//        var tasks: [Task] = []
//    }
//
//    // MARK: - Actions
//
//    struct Add: Action {
//        let task: Task
//    }
//
//    struct Delete: Action {
//        let task: Task
//    }
//
//    struct Move: Action {
//        let from: IndexSet
//        let to: Int
//    }
//
//    struct Complete: Action {
//        let task: Task
//    }
//    
//    // MARK: - Reducers
//
//    static func reducer(state: State, action: Action) -> State {
//        var tasks = state.tasks
//        switch action {
//            case let action as Add:
//                tasks.append(action.task)
//            case let action as Delete:
//                if let index = tasks.firstIndex(of: action.task) {
//                    tasks.remove(at: index)
//                }
//            case let action as Move:
//                tasks.move(fromOffsets: action.from, toOffset: action.to)
//            case let action as Complete:
//                if let index = tasks.firstIndex(of: action.task) {
//                    tasks[index].completed.toggle()
//                }
//            default:
//                break
//        }
//        return State(tasks: tasks)
//    }
//}
//
//extension TaskService.State {
//    static let mock = [
//        Task(title: "Implement UI", priority: .medium, completed: true),
//        Task(title: "Connect to Firebase", priority: .medium, completed: false),
//        Task(title: "????", priority: .high, completed: false),
//        Task(title: "PROFIT!!!", priority: .high, completed: false)
//    ]
//}
