//
//  TaskList.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

import SwiftRex
import CombineRex

struct TaskList: View {
    @ObservedObject var viewModel: ObservableViewModel<Action, State>
    let rowView: (String) -> CheckmarkCellView
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.viewModel.state.tasks, id: \.id) { rowView($0.id) }
                        .onDelete { viewModel.dispatch(.remove($0)) }
                        .onMove { viewModel.dispatch(.move($0, $1)) }
                }
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("New Task")
                    }
                }
                .padding()
                .accentColor(Color(UIColor.systemRed))
            }
            .navigationBarTitle(viewModel.state.title)
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func addTodo() {
        viewModel.dispatch(.add("Type something in..."))
    }
}

#if DEBUG
struct TaskList_Previews: PreviewProvider {
    static let stateMock = AppState.mock
    static let mockStore = ObservableViewModel<AppAction, AppState>.mock(
        state: stateMock,
        action: { action, _, state in
            state = Reducer.app.reduce(action, state)
        }
    )
    static var previews: some View {
        Group {
            TaskList(
                viewModel: TaskList.viewModel(
                    store: mockStore.projection(action: AppAction.task, state: \AppState.tasks)
                ),
                rowView: { Router.taskListRowView(store: mockStore, taskId: $0) }
            )
        }
    }
}
#endif
