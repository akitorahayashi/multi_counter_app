//
//  CounterViewModel.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

import Verge

final class CounterViewModel {
    private let store: CounterStore

    init(store: CounterStore = CounterStore()) {
        self.store = store
    }

    var counters: [Counter] {
        store.state.counters
    }

    func addCounter() {
        store.addCounter()
    }

    func removeCounter(at index: Int) {
        store.removeCounter(at: index)
    }

    func updateName(at index: Int, with name: String) {
        store.updateName(at: index, name: name)
    }

    func incrementCounter(at index: Int) {
        store.incrementCounter(at: index)
    }

    func decrementCounter(at index: Int) {
        store.decrementCounter(at: index)
    }

    func observeCounters(_ observer: @escaping ([Counter]) -> Void) -> VergeAnyCancellable {
        return store.observeState { state in
            observer(state.counters)
        }
    }
}
