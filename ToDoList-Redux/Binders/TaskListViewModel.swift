//
//  TaskView.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/4/20.
//

import Foundation
import SwiftRex

//extension TaskList {
enum TaskListViewModel {

    static func viewModel<S: StoreType>(store: S) -> StoreProjection<ViewEvent, ViewState>
//    where S.ActionType == TaskAction, S.StateType == TaskState {
    where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: Self.handleViewEvent, state: Self.prepareViewState)
    }
    
    static func handleViewEvent(_ viewEvent: ViewEvent) -> AppAction? {
        switch viewEvent {
            case .tapAdd(let title): return .task(.add(Task(title: title, priority: .low, completed: false)))
            case .tapDelete(let offset): return .task(.remove(offset))
            case .tapComplete(let id): return .task(.toggle(id))
        }
    }
    
    static func prepareViewState(from state: AppState) -> ViewState {
        ViewState(
            title: state.task.title,
            tasks: state.task.tasks,
            newTaskButtonTitle: "New Task",
            newTaskButtonImage: "plus.circle.fill"
        )
    }
    
    // Having ViewEvents and ViewState is totally optional, but recommended to avoid Model in the ViewController
    // There's an extra effort to make a store projection, but at the same time gives a place to put UI formatting logic
    enum ViewEvent {
        case tapAdd(title: String)
        case tapDelete(indexes: IndexSet)
        case tapComplete(id: String)
    }
    
    struct ViewState: Equatable {
        let title: String
        let tasks: [Task]
        let newTaskButtonTitle: String
        let newTaskButtonImage: String
        
        static var empty: ViewState {
            .init(title: "Tasks", tasks: [], newTaskButtonTitle: "New Task", newTaskButtonImage: "plus.circle.fill")
        }
        
        static var mock: ViewState {
            .init(title: "All Tasks",
                  tasks: [
                    Task(title: "Implement UI", priority: .medium, completed: true),
                    Task(title: "Connect to Firebase", priority: .medium, completed: false),
                    Task(title: "????", priority: .high, completed: false),
                    Task(title: "PROFIT!!!", priority: .high, completed: false)
                  ],
                  newTaskButtonTitle: "New Task",
                  newTaskButtonImage: "plus.circle.fill")
        }
    }
}
