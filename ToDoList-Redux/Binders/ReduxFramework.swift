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
    case task(TaskList.Action)
}


// MARK: - STATE

struct AppState: Equatable {
    var appLifecycle: AppLifecycle
    var task: TaskList.State
    
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

extension Reducer where ActionType == AppAction, StateType == AppState {
    static let app = Reducer<TaskList.Action, TaskList.State>.task.lift(
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
    public var task: TaskList.Action? {
        get {
            guard case let .task(value) = self else { return nil }
            return value
        }
        set {
            guard case .task = self, let newValue = newValue else { return }
            self = .task(newValue)
        }
    }
}


// MARK: - EXTENSIONS

extension TaskList {
    
    static func viewModel<S: StoreType>(store: S) -> ObservableViewModel<TaskList.Action, TaskList.State>
    where S.ActionType == AppAction, S.StateType == AppState {
        store
            .projection(action: Self.transform, state: Self.transform)
            .asObservableViewModel(initialState: .empty)
    }
    
    private static func transform(_ viewAction: TaskList.Action) -> AppAction? {
        switch viewAction {
            case let .add(title): return .task(.add(title))
            case let .remove(offset): return .task(.remove(offset))
            case let .move(offset, index): return .task(.move(offset, index))
            case let .toggle(id): return .task(.toggle(id))
        }
    }
    
    private static func transform(from state: AppState) -> TaskList.State {
        TaskList.State(
            title: state.task.title,
            tasks: state.task.tasks
        )
    }
}
