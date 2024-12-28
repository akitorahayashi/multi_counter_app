//
//  AppState.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import Verge

struct AppState: Equatable {
    var counters: [Counter] = []
}

let store = Store(initialState: AppState(), logger: nil)
