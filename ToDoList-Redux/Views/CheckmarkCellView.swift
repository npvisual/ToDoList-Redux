//
//  TaskItem.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

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

struct CheckmarkCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckmarkCellView(title: "This is a new task",
                     imageName: "circle",
                     toggle: { })
            CheckmarkCellView(title: "Another task !",
                     imageName: "checkmark.circle.fill",
                     toggle: { })
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
