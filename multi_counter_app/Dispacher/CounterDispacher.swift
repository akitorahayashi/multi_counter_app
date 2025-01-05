//
//  CounterDispacher.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

final class CounterDispatcher {
    static let shared = CounterDispatcher()
    private init() {}
    
    private var actionHandlers: [(CounterAction) -> Void] = []
    
    func register(callback: @escaping (CounterAction) -> Void) {
        actionHandlers.append(callback)
    }
    
    func dispatch(action: CounterAction) {
        actionHandlers.forEach { $0(action) }
    }
}
