//
//  ToDoList_ReduxApp.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

@main
struct ToDoList_ReduxApp: App {
    @StateObject var store = World
        .origin
        .store()
        .asObservableViewModel(initialState: .empty)

    var body: some Scene {
        WindowGroup {
            Router.taskListView(store: store)
        }
    }
}
