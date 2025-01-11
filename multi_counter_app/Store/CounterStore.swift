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

private let userDefaultsKeyForCounterState = "CounterStateKey"

final class CounterStore {
    static let shared = CounterStore()
    private let store: Store<CounterState, Never>
    
    private init(initialState: CounterState = CounterState()) {
        // 初期化時にUserDefaultsからデータをロード
        let savedState = CounterStore.loadStateFromUserDefaults() ?? initialState
        self.store = Store<CounterState, Never>(initialState: savedState, logger: nil)
    }
    
    var state: CounterState {
        store.state.root
    }
    
    func handleAction(action: CounterAction) {
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
            case .incrementCounter(let index):
                guard index < state.counters.count else { return }
                state.counters[index].countNum += 1
            case .decrementCounter(let index):
                guard index < state.counters.count else { return }
                state.counters[index].countNum -= 1
            }
        }
        saveStateToUserDefaults()
    }
    
    // 状態の監視
    func observeState(_ observer: @escaping (CounterState) -> Void) {
        store.sinkState { changes in
            observer(changes.root)
        }.storeWhileSourceActive()
    }
    
    // UserDefaultsに状態を保存
    func saveStateToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(self.state.counters)
            UserDefaults.standard.set(data, forKey: userDefaultsKeyForCounterState)
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save state: \(error)")
        }
    }
    
    // UserDefaultsから状態をロード
    private static func loadStateFromUserDefaults() -> CounterState? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKeyForCounterState) else { return nil }
        do {
            let counters = try JSONDecoder().decode([Counter].self, from: data)
            return CounterState(counters: counters)
        } catch {
            print("Failed to load state: \(error)")
            return nil
        }
    }
}
