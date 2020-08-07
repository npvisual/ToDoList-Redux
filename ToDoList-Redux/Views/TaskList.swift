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
    
    @ObservedObject var viewModel: ObservableViewModel<TaskAction, TaskState>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.viewModel.state.tasks, id: \.id) { (item: Task) -> CheckmarkCellContainerView in
                        let cellViewModel: ObservableViewModel<CheckmarkCellContainerView.Action, CheckmarkCellContainerView.State> = viewModel.projection(
                            action: { viewaction in
                                switch viewaction {
                                    case .toggle: return .toggle(item.id)
                                }
                            },
                            state: { state in
                                CheckmarkCellContainerView.State(title: item.title,
                                                                 imageName: item.completed ? "checkmark.circle.fill" : "circle")
                            }).asObservableViewModel(initialState: CheckmarkCellContainerView.State(title: "", imageName: "circle"))
                        return CheckmarkCellContainerView(viewModel: cellViewModel)
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
            .navigationBarTitle("Tasks")
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
