//
//  ToDoList_ReduxApp.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

@main
struct ToDoList_ReduxApp: App {
    
//    @StateObject private var appViewModel = AppViewModel.viewModel(store: World.origin.store()).asObservableViewModel(initialState: .empty)

    private static let store = World.origin.store()
    private static let viewModel = TaskListViewModel.viewModel(store: store)
    
    @StateObject var taskViewModel = viewModel.asObservableViewModel(initialState: .mock)
    
    var body: some Scene {
        WindowGroup {
            TaskList(viewModel: taskViewModel)
        }
    }
}
