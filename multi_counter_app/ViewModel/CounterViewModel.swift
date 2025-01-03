//
//  CounterViewModel.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import UIKit
import Verge

final class CounterViewModel {
    static let shared = CounterViewModel()
    
    struct CounterState: Equatable {
        var counters: [Counter] = []
    }
    
    private let store: Store<CounterState, Never>
    
    private init () {
        self.store = Store<CounterState, Never>(initialState: CounterState(), logger: nil)
    }
    // 現在のカウンター配列を取得
    var getCounters: [Counter] {
        get {
            store.state.counters
        }
    }
    
    // MARK: - Counterの追加や削除を行う
    func addCounter() {
        store.commit { state in
            let newCounter = Counter(id: UUID(), countNum: 0)
            state.counters.append(newCounter)
        }
    }
    
    func removeCounter(at index: Int) {
        guard index < getCounters.count else { return }
        let _ = store.commit { state in
            state.counters.remove(at: index)
        }
    }
    // MARK: - Counterの名前変更を行う
    func updateName(at index: Int, with name: String) {
        guard index < getCounters.count else { return }
        store.commit { state in
            state.counters[index].name = name
        }
    }
    
    // MARK: - counterの値を増減させる
    func incrementCounter(at index: Int) {
        guard index < getCounters.count else { return }
        store.commit { state in
            state.counters[index].countNum += 1
        }
    }
    
    func decrementCounter(at index: Int) {
        store.commit { state in
            state.counters[index].countNum -= 1
        }
    }
    
    // 状態の変更を監視
    func observeState(_ observer: @escaping (CounterState) -> Void) -> VergeAnyCancellable {
        let subscription = store.sinkState { changes in
            observer(changes.root) // `root`プロパティを使用して現在の状態を取得
        }
        return VergeAnyCancellable(subscription)
    }
    
}
