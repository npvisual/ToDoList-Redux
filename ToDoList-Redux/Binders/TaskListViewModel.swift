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
    
    static func viewModel<S: StoreType>(store: S) -> ObservableViewModel<TaskAction, TaskState>
    where S.ActionType == AppAction, S.StateType == AppState {
        store
            .projection(action: Self.transform, state: Self.transform)
            .asObservableViewModel(initialState: .empty)
    }
    
    private static func transform(_ viewAction: TaskAction) -> AppAction? {
        switch viewAction {
            case let .add(title): return .task(.add(title))
            case let .remove(offset): return .task(.remove(offset))
            case let .toggle(id): return .task(.toggle(id))
        }
    }
    
    private static func transform(from state: AppState) -> TaskState {
        TaskState(
            title: state.task.title,
            tasks: state.task.tasks
        )
    }
}
