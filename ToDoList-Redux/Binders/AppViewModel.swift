//
//  AppViewModel.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 8/5/20.
//

import Foundation
import SwiftRex

//extension TaskList {
enum AppViewModel {
    
    static func viewModel<S: StoreType>(store: S) -> StoreProjection<ViewEvent, ViewState>
    where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: Self.handleViewEvent, state: Self.prepareViewState)
    }
    
    static func handleViewEvent(_ viewEvent: ViewEvent) -> AppAction? {
        switch viewEvent {
            case .started: return .none
        }
    }
    
    static func prepareViewState(from state: AppState) -> ViewState {
        ViewState(
            title: "Task Application"
        )
    }
    
    // Having ViewEvents and ViewState is totally optional, but recommended to avoid Model in the ViewController
    // There's an extra effort to make a store projection, but at the same time gives a place to put UI formatting logic
    enum ViewEvent {
        case started
    }
    
    struct ViewState: Equatable {
        let title: String
        
        static var empty: ViewState {
            .init(title: "Tasks")
        }
    }
}
