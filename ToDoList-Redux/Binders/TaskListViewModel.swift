//
//  TaskView.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/4/20.
//

import Foundation

extension TaskList {
    // MARK: - STATE
    struct State: Equatable {
        var title: String
        var tasks: [Item]
        
        struct Item: Equatable, Identifiable {
            let id: String
        }

        static var empty = State(title: "Tasks", tasks: [])
    }
    
    // MARK: - ACTIONS
    enum Action {
        case add
        case remove(IndexSet)
        case move(IndexSet, Int)
    }
}
