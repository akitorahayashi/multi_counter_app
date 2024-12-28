//
//  AppState.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import Verge

struct CountersState: Equatable {
    var counters: [Counter] = []
}

let store = Store<CountersState, Never>(initialState: CountersState(), logger: nil)
