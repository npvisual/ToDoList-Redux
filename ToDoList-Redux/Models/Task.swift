//
//  Task.swift
//  ToDoList-ViewModel
//
//  Created by Nicolas Philippe on 7/30/20.
//

import Foundation

enum TaskPriority: String, Codable {
    case high
    case medium
    case low
}

struct Task: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var priority: TaskPriority
    var completed: Bool
}

extension TaskPriority: Comparable, Equatable {
    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        if lhs != rhs {
            switch (lhs, rhs) {
                case (high, medium), (high, low), (medium, low): return false
                case (medium, high), (low, high), (low, medium): return true
                default: return false
            }
        } else { return false }
    }
}
