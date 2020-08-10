//
//  TaskView.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/4/20.
//

import Foundation

import SwiftRex
import CombineRex

extension TaskList {
    
    // MARK: - STATE
    struct State: Equatable {
        var title: String
        var tasks: [Task]
        
        static var empty: State {
            .init(title: "Tasks", tasks: [])
        }
        
        static var mock: State {
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
    enum Action {
        case add(String)
        case remove(IndexSet)
        case move(IndexSet, Int)
        case toggle(CheckmarkCellView.Action)
    }
}

// MARK: - REDUCERS

extension Reducer where ActionType == TaskList.Action, StateType == TaskList.State {
    static let task = Reducer { action, state in
        var state = state
        switch action {
            case let .add(title):
                state.tasks.append(Task(title: title, priority: .medium, completed: false))
            case let .remove(offset):
                state.tasks.remove(atOffsets: offset)
            case let .move(offset, index):
                state.tasks.move(fromOffsets: offset, toOffset: index)
            case let .toggle(CheckmarkCellView.Action.toggle(id)):
                if let index = state.tasks.firstIndex(where: {$0.id == id}) {
                    state.tasks[index].completed.toggle()
                }
        }
        return state
    }
}

// MARK: - PROJECTIONS

extension CheckmarkCellView {
    
    static func viewModel<S: StoreType>(store: S, taskId: String) -> ObservableViewModel<CheckmarkCellView.Action, CheckmarkCellView.State>
    where S.ActionType == TaskList.Action, S.StateType == TaskList.State {
        let task = store.mapState { state in state.tasks.first { $0.id == taskId } }
        return task
            .projection(action: Self.transform, state: Self.transform)
            .asObservableViewModel(initialState: .empty)
    }
    
    static func transform(_ viewAction: CheckmarkCellView.Action) -> TaskList.Action? {
        switch viewAction {
            case let .toggle(id): return .toggle(.toggle(id))
        }
    }
    
    static func transform(from state: Task?) -> CheckmarkCellView.State {
        guard let state = state else { return CheckmarkCellView.State.empty }
        return CheckmarkCellView.State(
            id: state.id,
            title: state.title,
            imageName: state.completed ? "checkmark.circle.fill" : "circle"
        )
    }
}
