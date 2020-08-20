//
//  TaskList.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

import SwiftRex
import CombineRex
import CombineRextensions

struct TaskList: View {
    @ObservedObject var viewModel: ObservableViewModel<Action, State>
    let rowProducer: ViewProducer<String, CheckmarkCellView>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.viewModel.state.tasks) { rowProducer.view($0.id) }
                        .onDelete { viewModel.dispatch(.remove($0)) }
                        .onMove { viewModel.dispatch(.move($0, $1)) }
                }
                Button(action: { viewModel.dispatch(.add) }) {
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
                    store: mockStore.projection(action: AppAction.list, state: \AppState.tasks)
                ),
                rowProducer: ViewProducers.checkmarkCell(store: mockStore)
            )
        }
    }
}
#endif
