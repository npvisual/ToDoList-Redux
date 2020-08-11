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
        var tasks: [Item]
        
        static var empty: State {
            .init(title: "Tasks", tasks: [])
        }
        
        struct Item: Equatable, Identifiable {
            let id: String
        }
    }
    
    // MARK: - ACTIONS
    enum Action {
        case add(String)
        case remove(IndexSet)
        case move(IndexSet, Int)
    }
}

// MARK: - REDUCERS

extension Reducer where ActionType == TaskAction, StateType == [Task] {
    static let task = Reducer { action, state in
        var state = state
        switch action {
            case let .add(title):
                state.append(Task(title: title, priority: .medium, completed: false))
            case let .remove(offset):
                state.remove(atOffsets: offset)
            case let .move(offset, index):
                state.move(fromOffsets: offset, toOffset: index)
            case let .toggle(id):
                if let index = state.firstIndex(where: { $0.id == id} ) {
                    state[index].completed.toggle()
                }
        }
        return state
    }
}

// MARK: - PROJECTIONS

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
