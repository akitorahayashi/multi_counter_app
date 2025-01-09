//
//  CounterStore.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

import Foundation
import Verge

struct CounterState: Equatable {
    var counters: [Counter] = [Counter(id: UUID(), name: nil, countNum: 0)]
}

final class CounterStore {
    private let store: Store<CounterState, Never>

    init(initialState: CounterState = CounterState()) {
        self.store = Store<CounterState, Never>(initialState: initialState, logger: nil)
    }

    var state: CounterState {
        store.state.root
    }

    // Add a new counter
    func addCounter() {
        store.commit { state in
            let newCounter = Counter(id: UUID(), countNum: 0)
            state.counters.append(newCounter)
        }
    }

    // Remove a counter by index
    func removeCounter(at index: Int) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters.remove(at: index)
        }
    }

    // Update the name of a counter
    func updateName(at index: Int, name: String) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters[index].name = name
        }
    }

    // Increment the counter value
    func incrementCounter(at index: Int) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters[index].countNum += 1
        }
    }

    // Decrement the counter value
    func decrementCounter(at index: Int) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters[index].countNum -= 1
        }
    }

    
    func observeState(_ observer: @escaping (CounterState) -> Void) -> VergeAnyCancellable {
        let subscription = store.sinkState { changes in
            observer(changes.root)
        }
        return VergeAnyCancellable(subscription)
    }
}

