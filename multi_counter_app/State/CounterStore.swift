//
//  CounterStore.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/05.
//

import Foundation
import Verge

final class CounterStore {
    private let store: Store<CounterState, Never>

    init(initialState: CounterState = CounterState()) {
        self.store = Store<CounterState, Never>(initialState: initialState, logger: nil)
    }
    
    var state: CounterState {
        store.state.root
    }

    // アクションを処理する
    func dispatch(action: CounterAction) {
        store.commit { state in
            switch action {
            case .addCounter:
                let newCounter = Counter(id: UUID(), countNum: 0)
                state.counters.append(newCounter)

            case .removeCounter(let index):
                guard index < state.counters.count else { return }
                state.counters.remove(at: index)

            case .updateName(let index, let name):
                guard index < state.counters.count else { return }
                state.counters[index].name = name

            case .increment(let index):
                guard index < state.counters.count else { return }
                state.counters[index].countNum += 1

            case .decrement(let index):
                guard index < state.counters.count else { return }
                state.counters[index].countNum -= 1
            }
        }
    }

    /// 状態の変更を監視する
    func observeState(_ observer: @escaping (CounterState) -> Void) -> VergeAnyCancellable {
        let subscription = store.sinkState { changes in
            observer(changes.root)
        }
        return VergeAnyCancellable(subscription)
    }
}
