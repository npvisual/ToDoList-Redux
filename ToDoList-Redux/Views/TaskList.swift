//
//  TaskList.swift
//  ToDoList-Redux
//
//  Created by Nicolas Philippe on 7/30/20.
//

import SwiftUI

struct TaskList: View {
    
    @EnvironmentObject var service: TaskService
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach (self.service.tasks.indexed(), id: \.1.id) { index, _ in
                        TaskItem(task: self.$service.tasks[index])
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
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
        service.tasks.remove(atOffsets: indexes)
    }
    
    private func move(_ indexes: IndexSet, to offset: Int) {
        service.tasks.move(fromOffsets: indexes, toOffset: offset)
    }
    
    private func addTodo() {
        let draft = ""
        let newTodo = Task(title: draft, priority: .medium, completed: false)
        service.tasks.insert(newTodo, at: 0)
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList().environmentObject(TaskService())
    }
}
