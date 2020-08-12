//
//  ToDoList_ReduxApp.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

@main
struct ToDoList_ReduxApp: App {
    @StateObject var store = World.origin.store().asObservableViewModel(initialState: .empty)

    var body: some Scene {
        WindowGroup {
            Router.taskListView(store: store)
        }
    }
}

import SwiftRex
struct Router {
    static func taskListView<S: StoreType>(store: S) -> TaskList
    where S.StateType == AppState, S.ActionType == AppAction {
        TaskList(
            viewModel: TaskList.viewModel(store: store.projection(action: AppAction.list, state: \AppState.tasks)),
            rowView: { id in taskListRowView(store: store, taskId: id) }
        )
    }

    static func taskListRowView<S: StoreType>(store: S, taskId: String) -> CheckmarkCellView
    where S.StateType == AppState, S.ActionType == AppAction {
        CheckmarkCellView(
            viewModel: CheckmarkCellView.viewModel(
                store: store.projection(action: AppAction.task, state: \AppState.tasks),
                taskId: taskId
            )
        )
    }
}
