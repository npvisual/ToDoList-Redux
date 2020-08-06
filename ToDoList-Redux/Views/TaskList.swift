//
//  TaskList.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI
import CombineRex

struct TaskList: View {
    
    @ObservedObject var viewModel: ObservableViewModel<TaskListViewModel.ViewEvent, TaskListViewModel.ViewState>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.viewModel.state.tasks, id: \.id) { (item: Task) in
                        CheckmarkCellView(title: item.title,
                                          imageName: item.completed ? "checkmark.circle.fill" : "circle") {
                            viewModel.dispatch(.tapComplete(id: item.id))}
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
            PreviewWrapper()
        }
    }
    
    struct PreviewWrapper: View {
        @State var viewModel: ObservableViewModel = ObservableViewModel<TaskListViewModel.ViewEvent, TaskListViewModel.ViewState>.mock(state: TaskListViewModel.ViewState.mock)
        
        var body: some View {
            TaskList(viewModel: viewModel)
        }
    }
}
#endif
