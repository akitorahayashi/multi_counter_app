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
        let tableView = app.tables["CounterTableView"]
        // セルの中のボタンを取得
        let defaultCell = tableView.cells.element(boundBy: 0)
        let incrementButton = defaultCell.buttons["+"]
        // セルに紐づいている現在値を取得
        let countLabel = defaultCell.staticTexts.matching(identifier: "CounterOfThisCell").element
        var currentValue = Int(countLabel.label)
        
        // +ボタンをタップして値が増えることを確認
        incrementButton.tap()
        let incrementedValue = Int(countLabel.label)
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(incrementedValue, currentValue! + 1, "+ボタンを押してもcountが1増えていない")
        
        // +ボタンを複数回タップして値が正しく増えることを確認
        for _ in 0..<5 {
            incrementButton.tap()
        }
        let furtherIncrementedValue = Int(countLabel.label)
        XCTAssertEqual(furtherIncrementedValue, currentValue! + 6, "複数回タップしたときにcountが正しく増加できていない")
    }
    
    func testDecrementButtonWorks() throws {
        let tableView = app.tables["CounterTableView"]
        // セルの中のボタンを取得
        let defaultCell = tableView.cells.element(boundBy: 0)
        let decrementButton = defaultCell.buttons["-"]
        // セルに紐づいている現在地を取得
        let countLabel = defaultCell.staticTexts.matching(identifier: "CounterOfThisCell").element
        let currentValue = Int(countLabel.label)
        
        // -ボタンをタップして値が減ることを確認
        decrementButton.tap()
        let decrementedValue = Int(countLabel.label)
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(decrementedValue, currentValue! - 1, "-ボタンを押してもcountが1減っていない")
        
        // -ボタンを複数回タップして値が正しく減ることを確認
        for _ in 0..<5 {
            decrementButton.tap()
        }
        let furtherDecrementedValue = Int(countLabel.label)
        XCTAssertEqual(furtherDecrementedValue, currentValue! - 6, "複数回タップしたときにcountが正しく減少できていない")
    }
}
