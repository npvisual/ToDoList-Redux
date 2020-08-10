//
//  CheckmarkCellViewModel.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/7/20.
//

import Foundation

import SwiftRex

extension CheckmarkCellView {
    

    // MARK: - STATE
    struct State: Equatable {
        let id: String
        let title: String
        let imageName: String

        static var empty = State(id: UUID().uuidString,
                                 title: "Type to create a new task...",
                                 imageName: "circle")

        static var mock = State(id: UUID().uuidString,
                                title: "An incomplete task",
                                imageName: "circle")
    }

    // MARK: - ACTIONS
    enum Action {
        case toggle(String)
    }
}

// MARK: - REDUCERS

extension Reducer where ActionType == CheckmarkCellView.Action, StateType == CheckmarkCellView.State {
    static let cell = Reducer { action, state in
        var state = state
        switch action {
            case .toggle: break
        }
        return state
    }
}
