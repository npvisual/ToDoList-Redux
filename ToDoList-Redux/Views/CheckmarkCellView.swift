//
//  TaskItem.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

import SwiftRex
import CombineRex

struct CheckmarkCellView: View {

    @ObservedObject var viewModel: ObservableViewModel<Action, State>
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.state.imageName)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture { viewModel.dispatch(.toggle(viewModel.state.id))}
            Text(viewModel.state.title)
        }
    }
}

struct CheckmarkCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckmarkCellView(viewModel: .mock(state: .mock,
                                               action: { action, _, state in
                                                state = Reducer.cell.reduce(action, state)
                                               }
            )
            )
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
