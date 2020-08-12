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
    case add
    case remove(IndexSet)
    case move(IndexSet, Int)
    case toggle(String)
    case update(String, String)
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

extension Reducer where ActionType == TaskAction, StateType == [Task] {
    static let task = Reducer { action, state in
        var state = state
        switch action {
            case .add:
                state.append(Task(title: "", priority: .medium, completed: false))
            case let .remove(offset):
                state.remove(atOffsets: offset)
            case let .move(offset, index):
                state.move(fromOffsets: offset, toOffset: index)
            case let .toggle(id):
                if let index = state.firstIndex(where: { $0.id == id }) {
                    state[index].completed.toggle()
                }
            case let .update(id, title):
                if let index = state.firstIndex(where: { $0.id == id }) {
                    state[index].title = title
                }
        }
        return state
    }
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

// MARK: - PROJECTIONS

extension TaskList {
    static func viewModel<S: StoreType>(store: S) -> ObservableViewModel<TaskList.Action, TaskList.State>
    where S.ActionType == TaskAction, S.StateType == [Task] {
        store
            .projection(action: Self.transform, state: Self.transform)
            .asObservableViewModel(initialState: .empty)
    }
    
    private static func transform(_ viewAction: TaskList.Action) -> TaskAction? {
        switch viewAction {
            case .add: return .add
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

extension CheckmarkCellView {
    static func viewModel<S: StoreType>(store: S, taskId: String) -> ObservableViewModel<CheckmarkCellView.Action, CheckmarkCellView.State>
    where S.ActionType == TaskAction, S.StateType == [Task] {
        let task = store.mapState { state in state.first { $0.id == taskId } }
        return task
            .projection(action: Self.transform(taskId: taskId), state: Self.transform)
            .asObservableViewModel(initialState: .empty)
    }
    
    static func transform(taskId: String) -> (CheckmarkCellView.Action) -> TaskAction? {
        return { viewAction in
            switch viewAction {
                case .toggle: return .toggle(taskId)
                case let .update(title): return .update(taskId, title)
            }
        }
    }
    
    static func transform(from state: Task?) -> CheckmarkCellView.State {
        guard let state = state else { return CheckmarkCellView.State.empty }
        return CheckmarkCellView.State(
            title: state.title,
            imageName: state.completed ? "checkmark.circle.fill" : "circle"
        )
    }
}
