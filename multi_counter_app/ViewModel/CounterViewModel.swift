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
        CounterStore.shared.addCounter()
    }
    
    func removeCounter(at index: Int) {
        CounterStore.shared.removeCounter(at: index)
    }
    
    func updateName(at index: Int, with name: String) {
        CounterStore.shared.updateName(at: index, name: name)
    }
    
    func incrementCounter(at index: Int) {
        CounterStore.shared.incrementCounter(at: index)
    }
    
    func decrementCounter(at index: Int) {
        CounterStore.shared.decrementCounter(at: index)
    }
    
    func saveState() {
        CounterStore.shared.saveStateToUserDefaults()
    }
    
    func observeCounters(_ observer: @escaping ([Counter]) -> Void) -> VergeAnyCancellable {
        return CounterStore.shared.observeState { state in
            observer(state.counters)
        }
    }
}
