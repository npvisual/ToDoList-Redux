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
    
    @StateObject var taskViewModel = TaskList.viewModel(store: store)
    
    var body: some Scene {
        WindowGroup {
            TaskList(viewModel: taskViewModel)
        }
    }
}
