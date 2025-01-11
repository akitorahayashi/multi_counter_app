//
//  CounterViewModel.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

import Verge

final class CounterViewModel {
    var counters: [Counter] {
        CounterStore.shared.state.counters
    }
    
    func addCounter() {
        CounterStore.shared.handleAction(action: .addCounter)
    }
    
    func removeCounter(at index: Int) {
        CounterStore.shared.handleAction(action: .removeCounter(index: index))
    }
    
    func updateName(at index: Int, with name: String) {
        CounterStore.shared.handleAction(action: .updateName(index: index, name: name))
    }
    
    func incrementCounter(at index: Int) {
        CounterStore.shared.handleAction(action: .incrementCounter(index: index))
    }
    
    func decrementCounter(at index: Int) {
        CounterStore.shared.handleAction(action: .decrementCounter(index: index))
    }
    
    func observeCounters(_ observer: @escaping (CounterState) -> Void) {
        return CounterStore.shared.observeState { state in
            observer(state)
        }
    }
}
