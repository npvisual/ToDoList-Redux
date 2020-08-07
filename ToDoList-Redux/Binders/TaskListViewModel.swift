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

    static func viewModel<S: StoreType>(store: S) -> StoreProjection<Action, State>
    where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: Self.transform, state: Self.transform)
    }
    
    private static func transform(_ viewEvent: Action) -> AppAction? {
        switch viewEvent {
            case .tapAdd(let title): return .task(.add(Task(title: title, priority: .low, completed: false)))
            case .tapDelete(let offset): return .task(.remove(offset))
            case .tapComplete(let id): return .task(.toggle(id))
        }
    }
    
    private static func transform(from state: AppState) -> State {
        State(
            title: state.task.title,
            tasks: state.task.tasks,
            newTaskButtonTitle: "New Task",
            newTaskButtonImage: "plus.circle.fill"
        )
    }
    
    // Having ViewEvents and ViewState is totally optional, but recommended to avoid Model in the ViewController
    // There's an extra effort to make a store projection, but at the same time gives a place to put UI formatting logic
    enum Action {
        case tapAdd(title: String)
        case tapDelete(indexes: IndexSet)
        case tapComplete(id: String)
    }
    
    struct State: Equatable {
        let title: String
        var tasks: [Task]
        let newTaskButtonTitle: String
        let newTaskButtonImage: String
        
        static var empty: State {
            .init(title: "Tasks", tasks: [], newTaskButtonTitle: "New Task", newTaskButtonImage: "plus.circle.fill")
        }
        
        static var mock: State {
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
