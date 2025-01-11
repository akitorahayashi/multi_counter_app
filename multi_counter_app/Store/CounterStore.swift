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

private let userDefaultsKey = "CounterStateKey"

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

    // カウンターを追加
    func addCounter() {
        store.commit { state in
            let newCounter = Counter(id: UUID(), countNum: 0)
            state.counters.append(newCounter)
        }
        self.saveStateToUserDefaults()
    }

    // カウンターを削除
    func removeCounter(at index: Int) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters.remove(at: index)
        }
        self.saveStateToUserDefaults()
    }

    // カウンターの名前を更新
    func updateName(at index: Int, name: String) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters[index].name = name
        }
        self.saveStateToUserDefaults()
    }

    // カウンターの値を増加
    func incrementCounter(at index: Int) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters[index].countNum += 1
        }
        self.saveStateToUserDefaults()
    }

    // カウンターの値を減少
    func decrementCounter(at index: Int) {
        store.commit { state in
            guard index < state.counters.count else { return }
            state.counters[index].countNum -= 1
        }
        self.saveStateToUserDefaults()
    }

    // 状態の監視
    func observeState(_ observer: @escaping (CounterState) -> Void) -> VergeAnyCancellable {
        let subscription = store.sinkState { changes in
            observer(changes.root)
        }
        return VergeAnyCancellable(subscription)
    }

    // UserDefaultsに状態を保存
    func saveStateToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(self.state.counters)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save state: \(error)")
        }
    }

    // UserDefaultsから状態をロード
    private static func loadStateFromUserDefaults() -> CounterState? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        do {
            let counters = try JSONDecoder().decode([Counter].self, from: data)
            return CounterState(counters: counters)
        } catch {
            print("Failed to load state: \(error)")
            return nil
        }
    }
}
