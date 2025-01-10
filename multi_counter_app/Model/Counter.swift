//
//  Counter.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2024/12/28.
//

import Foundation

struct Counter: Equatable, Codable {
    let id: UUID
    var name: String?
    var countNum: Int

    mutating func increment() {
        countNum += 1
    }

    mutating func decrement() {
        countNum -= 1
    }
}


