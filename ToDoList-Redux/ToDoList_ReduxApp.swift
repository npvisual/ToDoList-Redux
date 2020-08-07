//
//  ToDoList_ReduxApp.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI
import CombineRex

@main
struct ToDoList_ReduxApp: App {
    
    private static let store = World.origin.store()
    private static let viewModel = TaskList.viewModel(store: store)
    
    @StateObject var taskViewModel = viewModel.asObservableViewModel(initialState: .mock)
    
    var body: some Scene {
        WindowGroup {
            TaskList(viewModel: taskViewModel)
        }
    }
}
