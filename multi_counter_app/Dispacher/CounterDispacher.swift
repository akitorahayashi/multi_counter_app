//
//  CounterDispacher.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

final class CounterDispatcher {
    static let shared = CounterDispatcher()
    private init() {}
    
    private var callbacks: [(CounterAction) -> Void] = []
    
    func register(callback: @escaping (CounterAction) -> Void) {
        callbacks.append(callback)
    }
    
    func dispatch(action: CounterAction) {
        callbacks.forEach { $0(action) }
    }
}
