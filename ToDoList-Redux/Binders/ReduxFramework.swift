//
//  ReduxFramework.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/4/20.
//

import Foundation

import SwiftRex
import LoggerMiddleware

// MARK: - ACTIONS

enum TaskAction {
    case add(String)
    case remove(IndexSet)
    case toggle(String)
}

enum AppAction {
    case task(TaskAction)
}


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

struct AppState: Equatable {
    var appLifecycle: AppLifecycle
    var task: TaskState
    
    static var empty: AppState {
        .init(appLifecycle: .backgroundInactive, task: .empty)
    }
    
    static var mock: AppState {
        .init(appLifecycle: .backgroundInactive, task: .mock)
    }
    
    enum AppLifecycle: Equatable {
        case backgroundActive
        case backgroundInactive
        case foregroundActive
        case foregroundInactive
    }
}


// MARK: - REDUCERS

extension Reducer where ActionType == TaskAction, StateType == TaskState {
    static let task = Reducer { action, state in
        var state = state
        switch action {
            case .add(let title):
                state.tasks.append(Task(title: title, priority: .medium, completed: false))
            case .remove(let offset):
                state.tasks.remove(atOffsets: offset)
            case .toggle(let id):
                if let index = state.tasks.firstIndex(where: {$0.id == id}) {
                    state.tasks[index].completed.toggle()
                }
        }
        return state
    }
}

extension Reducer where ActionType == AppAction, StateType == AppState {
    static let app = Reducer<TaskAction, TaskState>.task.lift(
        action: \AppAction.task,
        state: \AppState.task
    )
}


// MARK: - MIDDLEWARE

let appMiddleware = IdentityMiddleware<AppAction, AppAction, AppState>().logger()


// MARK: - STORE

class Store: ReduxStoreBase<AppAction, AppState> {
    private init() {
        super.init(
            subject: .combine(initialValue: .mock),
            reducer: Reducer.app,
            middleware: appMiddleware
        )
    }
    
    static let instance = Store()
}


// MARK: - WORLD

struct World {
    let store: () -> AnyStoreType<AppAction, AppState>
}

extension World {
    static let origin = World(
        store: { Store.instance.eraseToAnyStoreType() }
    )
}


// MARK: - PRISM

extension AppAction {
    public var task: TaskAction? {
        get {
            guard case let .task(value) = self else { return nil }
            return value
        }
//        set {
//            guard case .task = self, let newValue = newValue else { return }
//            self = .task(newValue)
//        }
    }
}

