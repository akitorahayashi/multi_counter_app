//
//  CounterCellTests.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/09.
//

import XCTest

class CounterCellTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = true
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    func testIncrementButtonWorks() throws {
        
    }
}
