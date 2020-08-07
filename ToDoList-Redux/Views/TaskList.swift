//
//  TaskList.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI
import CombineRex

struct TaskList: View {
    
    @ObservedObject var viewModel: ObservableViewModel<TaskListViewModel.Action, TaskListViewModel.State>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.viewModel.state.tasks, id: \.id) { (item: Task) -> CheckmarkCellContainerView in
                        let cellViewModel: ObservableViewModel<CheckmarkCellContainerView.Action, CheckmarkCellContainerView.State> = viewModel.projection(
                            action: { viewaction in
                                switch viewaction {
                                    case .toggle: return .tapComplete(id: item.id)
                                }
                            },
                            state: { state in
                                CheckmarkCellContainerView.State(title: item.title,
                                                                 imageName: item.completed ? "checkmark.circle.fill" : "circle")
                            }).asObservableViewModel(initialState: CheckmarkCellContainerView.State(title: "", imageName: "circle"))
                        return CheckmarkCellContainerView(viewModel: cellViewModel)
                    }
                    .onDelete(perform: delete)
//                    .onMove(perform: move)
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
    
    private func delete(_ indexes: IndexSet) {
        viewModel.dispatch(.tapDelete(indexes: indexes))
    }
    
//    private func move(_ indexes: IndexSet, to offset: Int) {
//        service.tasks.move(fromOffsets: indexes, toOffset: offset)
//    }
    
    private func addTodo() {
        viewModel.dispatch(.tapAdd(title: "Type something in..."))
    }
}

#if DEBUG
struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskList(viewModel: .mock(state: TaskListViewModel.State.mock,
                                      action: { action, _, state in
                                        switch action {
                                            case let .tapComplete(id: id):
                                                if let index = state.tasks.firstIndex(where: {$0.id == id}) {
                                                    state.tasks[index].completed.toggle()
                                                }

                                            case let .tapDelete(indexes: index): state.tasks.remove(atOffsets: index)
                                            case let .tapAdd(title: title): print("Add task with title : \(title)")
                                        }
                                      }
            )
            )
        }
    }
}
#endif
