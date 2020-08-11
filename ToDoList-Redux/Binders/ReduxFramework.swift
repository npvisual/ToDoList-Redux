//
//  ReduxFramework.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/4/20.
//

import Foundation

import SwiftRex
import LoggerMiddleware
import CombineRex

// MARK: - ACTIONS

enum AppAction {
    case appLifecycle(AppLifecycleAction)
    case task(TaskAction)
}

enum TaskAction {
    case add(String)
    case remove(IndexSet)
    case move(IndexSet, Int)
    case toggle(String)
}

// MARK: - STATE

struct AppState: Equatable {
    var appLifecycle: AppLifecycle
    var tasks: [Task]
    
    static var empty: AppState {
        .init(appLifecycle: .backgroundInactive, tasks: [])
    }

    static var mock: AppState {
        .init(
            appLifecycle: .backgroundInactive,
            tasks: [
                Task(title: "Implement UI", priority: .medium, completed: true),
                Task(title: "Connect to Firebase", priority: .medium, completed: false),
                Task(title: "????", priority: .high, completed: false),
                Task(title: "PROFIT!!!", priority: .high, completed: false)
            ]
        )
    }
}


// MARK: - REDUCERS


extension Reducer where ActionType == AppAction, StateType == AppState {
    static let app =
        Reducer<TaskAction, [Task]>.task.lift(
            action: \AppAction.task,
            state: \AppState.tasks
        ) <> Reducer<AppLifecycleAction, AppLifecycle>.lifecycle.lift(
            action: \AppAction.appLifecycle,
            state: \AppState.appLifecycle
        )
}


// MARK: - MIDDLEWARE

let appMiddleware =
    IdentityMiddleware<AppAction, AppAction, AppState>().logger()
    <> AppLifecycleMiddleware().lift(
        inputActionMap: { _ in nil },
        outputActionMap: AppAction.appLifecycle,
        stateMap: { _ in }
    )

// MARK: - STORE

class Store: ReduxStoreBase<AppAction, AppState> {
    private init() {
        super.init(
            subject: .combine(initialValue: .empty),
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

// MARK: - EXTENSIONS

extension TaskList {
    static func viewModel<S: StoreType>(store: S) -> ObservableViewModel<TaskList.Action, TaskList.State>
    where S.ActionType == TaskAction, S.StateType == [Task] {
        store
            .projection(action: Self.transform, state: Self.transform)
            .asObservableViewModel(initialState: .empty)
    }
    
    private static func transform(_ viewAction: TaskList.Action) -> TaskAction? {
        switch viewAction {
            case let .add(title): return .add(title)
            case let .remove(offset): return .remove(offset)
            case let .move(offset, index): return .move(offset, index)
        }
    }
    
    private static func transform(from state: [Task]) -> TaskList.State {
        TaskList.State(
            title: "Tasks",
            tasks: state.map { State.Item(id: $0.id) }
        )
    }
}
