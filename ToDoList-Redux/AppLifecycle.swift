//
//  AppLifecycleMiddleware.swift
//  ToDoList-Redux
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.08.20.
//

import Combine
import Foundation
import SwiftRex
import UIKit

enum AppLifecycleAction {
    case didEnterBackground
    case willEnterForeground
    case didBecomeActive
    case willBecomeInactive
}

enum AppLifecycle: Equatable {
    case backgroundActive
    case backgroundInactive
    case foregroundActive
    case foregroundInactive
}

extension Reducer where ActionType == AppLifecycleAction, StateType == AppLifecycle {
    static let lifecycle = Reducer { action, state in
        switch (state, action) {
        case (.backgroundActive, .didEnterBackground): return state
        case (.backgroundInactive, .didEnterBackground): return state
        case (.foregroundActive, .didEnterBackground): return .backgroundActive
        case (.foregroundInactive, .didEnterBackground): return .backgroundInactive

        case (.backgroundActive, .willEnterForeground): return .foregroundActive
        case (.backgroundInactive, .willEnterForeground): return .foregroundInactive
        case (.foregroundActive, .willEnterForeground): return state
        case (.foregroundInactive, .willEnterForeground): return state

        case (.backgroundActive, .didBecomeActive): return state
        case (.backgroundInactive, .didBecomeActive): return .backgroundActive
        case (.foregroundActive, .didBecomeActive): return state
        case (.foregroundInactive, .didBecomeActive): return .foregroundActive

        case (.backgroundActive, .willBecomeInactive): return .backgroundInactive
        case (.backgroundInactive, .willBecomeInactive): return state
        case (.foregroundActive, .willBecomeInactive): return .foregroundInactive
        case (.foregroundInactive, .willBecomeInactive): return state
        }
    }
}

// TODO: Later change to upcoming (0.8) EffectMiddleware
class AppLifecycleMiddleware: Middleware {
    typealias InputActionType = Never
    typealias OutputActionType = AppLifecycleAction
    typealias StateType = Void

    private var cancellable: AnyCancellable?

    func receiveContext(getState: @escaping GetState<StateType>, output: AnyActionHandler<OutputActionType>) {
        // TODO: Dependency Injection of publishers, so it's easier to mock this Middleware
        let notificationCenter = NotificationCenter.default
        cancellable = Publishers.Merge4(
            notificationCenter
                .publisher(for: UIApplication.didBecomeActiveNotification)
                .map { _ in AppLifecycleAction.didBecomeActive },
            notificationCenter
                .publisher(for: UIApplication.willResignActiveNotification)
                .map { _ in AppLifecycleAction.willBecomeInactive },
            notificationCenter
                .publisher(for: UIApplication.didEnterBackgroundNotification)
                .map { _ in AppLifecycleAction.didEnterBackground },
            notificationCenter
                .publisher(for: UIApplication.willEnterForegroundNotification)
                .map { _ in AppLifecycleAction.willEnterForeground }
        ).sink { action in
            output.dispatch(action)
        }
    }

    func handle(action: InputActionType, from dispatcher: ActionSource, afterReducer: inout AfterReducer) {
    }
}
