//
//  ActionPrism.swift
//  ToDoList-Redux
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.08.20.
//

import Foundation

// TODO: Use code-generation

// MARK: - PRISM

extension AppAction {
    public var task: TaskAction? {
        get {
            guard case let .task(value) = self else { return nil }
            return value
        }
        set {
            guard case .task = self, let newValue = newValue else { return }
            self = .task(newValue)
        }
    }

    public var isTask: Bool {
        self.task != nil
    }
}

extension AppAction {
    public var appLifecycle: AppLifecycleAction? {
        get {
            guard case let .appLifecycle(value) = self else { return nil }
            return value
        }
        set {
            guard case .appLifecycle = self, let newValue = newValue else { return }
            self = .appLifecycle(newValue)
        }
    }

    public var isAppLifecycle: Bool {
        self.appLifecycle != nil
    }
}
