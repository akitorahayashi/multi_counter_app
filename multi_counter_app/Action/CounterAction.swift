//
//  CounterAction.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/11.
//

enum CounterAction {
    case addCounter
    case removeCounter(index: Int)
    case updateName(index: Int, name: String)
    case incrementCounter(index: Int)
    case decrementCounter(index: Int)
}
