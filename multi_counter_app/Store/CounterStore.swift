//
//  CounterStore.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

import Foundation

final class CounterStore {
    static let shared = CounterStore()
    
    private(set) var counters: [Counter] = [] {
        didSet {
            notifyObservers()
        }
    }
    
    private var observers: [(CounterStore) -> Void] = []
    
    private init() {
        CounterDispatcher.shared.register { [weak self] action in
            self?.handle(action: action)
        }
    }
    
    func observe(_ observer: @escaping (CounterStore) -> Void) {
        observers.append(observer)
        observer(self) // Initial call
    }
    
    private func notifyObservers() {
        observers.forEach { $0(self) }
    }
    
    private func handle(action: CounterAction) {
        switch action {
        case .addCounter:
            counters.append(Counter(id: UUID(), name: nil, countNum: 0))
        case .removeCounter(let index):
            guard counters.indices.contains(index) else { return }
            counters.remove(at: index)
        case .updateName(let index, let name):
            guard counters.indices.contains(index) else { return }
            counters[index].name = name
        case .increment(let index):
            guard counters.indices.contains(index) else { return }
            counters[index].countNum += 1
        case .decrement(let index):
            guard counters.indices.contains(index) else { return }
            counters[index].countNum -= 1
        }
    }
}
