//
//  TaskItem.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI
import CombineRex

struct CheckmarkCellView: View {
    
    let title: String
    let imageName: String
    let toggle: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture(perform: toggle)
            Text(title)
        }
    }
}

struct CheckmarkCellContainerView: View {
    
    struct State: Equatable {
        let title: String
        let imageName: String
    }
    
    enum Action {
        case toggle
    }
    
    @ObservedObject var viewModel: ObservableViewModel<Action, State>

    var body: some View {
        CheckmarkCellView(
            title: viewModel.state.title,
            imageName: viewModel.state.imageName) { viewModel.dispatch(.toggle)}
    }
}

struct CheckmarkCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckmarkCellView(title: "This is a new task",
                              imageName: "circle",
                              toggle: {})
            CheckmarkCellView(title: "This is a completed task !",
                              imageName: "checkmark.circle.fill",
                              toggle: {})
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
