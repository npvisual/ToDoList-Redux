//
//  CheckmarkCellViewModel.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/7/20.
//

import Foundation

extension CheckmarkCellView {
    // MARK: - STATE
    struct State: Equatable {
        let title: String
        let imageName: String

        static var empty = State(title: "",
                                 imageName: "circle")
    }

    // MARK: - ACTIONS
    enum Action {
        case toggle
        case update(String)
    }
}
