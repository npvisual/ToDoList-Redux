//
//  CheckmarkCellViewProducer.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/20/20.
//

import Foundation
import SwiftRex
import CombineRextensions

struct ViewProducers {
    
    /// Will produce a TaskList with the appropriate Store projection and the given producer for the rows of the list.
    /// - Parameter store: the application store
    /// - Returns: a TaskList view configured with the appropriate Store projection and row view producer.
    static func taskList<S: StoreType>(store: S) -> ViewProducer<Void, TaskList> where S.StateType == AppState, S.ActionType == AppAction {
        ViewProducer {
            TaskList(
                viewModel: TaskList.viewModel(
                    store: store.projection(
                        action: AppAction.list,
                        state: \AppState.tasks)),
                rowProducer: checkmarkCell(store: store)
            )
        }
    }
    
    /// Will produce a CheckmarkCellView with the appropriate Store projection for a given task identifier
    /// - Parameter store: the application store
    /// - Returns: a CheckmarkView view configured with the appropriate Stoore projection.
    static func checkmarkCell<S: StoreType>(store: S) -> ViewProducer<String, CheckmarkCellView> where S.StateType == AppState, S.ActionType == AppAction {
        ViewProducer { taskId in
            CheckmarkCellView(
                viewModel: CheckmarkCellView.viewModel(
                    store: store.projection(
                        action: AppAction.task,
                        state: \AppState.tasks),
                    taskId: taskId)
            )
        }
    }
}
