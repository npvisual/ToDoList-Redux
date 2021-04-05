//
//  TaskItem.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

import SwiftRex
import CombineRex
import CombineRextensions

struct CheckmarkCellView: View {

    @ObservedObject var viewModel: ObservableViewModel<Action, State>
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.state.imageName)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture { viewModel.dispatch(.toggle) }
            TextField("Enter task here...", text: viewModel.binding[\.title] { Action.update($0)}) 
        }
    }
}

#if DEBUG
struct CheckmarkCellView_Previews: PreviewProvider {
    static let stateMock = AppState.mock
    static let mockStore = ObservableViewModel<AppAction, AppState>.mock(
        state: stateMock,
        action: { action, _, state in
            Reducer.app.reduce(action, &state)
        }
    )
    static var previews: some View {
        Group {
            CheckmarkCellView(
                viewModel:
                    CheckmarkCellView.viewModel(
                        store: mockStore.projection(action: AppAction.task, state: \AppState.tasks),
                        taskId: stateMock.tasks.first!.id
                    )
            )
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
