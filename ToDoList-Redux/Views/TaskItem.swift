//
//  TaskItem.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

struct TaskItem: View {
    
    var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20) // (12)
            Text(task.title)
        }
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskItem(task: testDataTasks[0])
            TaskItem(task: testDataTasks[1])
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
