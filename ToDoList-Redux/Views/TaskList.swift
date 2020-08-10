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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.viewModel.state.tasks, id: \.id) { (item: Task) -> CheckmarkCellView in
                        let cellViewModel = CheckmarkCellView.viewModel(store: viewModel, taskId: item.id)
                        return CheckmarkCellView(viewModel: cellViewModel)
                    }
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
    static var previews: some View {
        Group {
            TaskList(viewModel: .mock(state: .mock,
                                      action: { action, _, state in
                                        state = Reducer.task.reduce(action, state)
                                      }
            )
            )
        }
    }
}
#endif
