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
        store.dispatch(action: .addCounter)
    }

    func removeCounter(at index: Int) {
        store.dispatch(action: .removeCounter(index: index))
    }

    func updateName(at index: Int, with name: String) {
        store.dispatch(action: .updateName(index: index, name: name))
    }

    func incrementCounter(at index: Int) {
        store.dispatch(action: .increment(index: index))
    }

    func decrementCounter(at index: Int) {
        store.dispatch(action: .decrement(index: index))
    }

    func observeCounters(_ observer: @escaping ([Counter]) -> Void) -> VergeAnyCancellable {
        return store.observeState { state in
            observer(state.counters)
        }
    }
}
