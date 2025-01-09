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
        XCTAssertEqual(currentValue! + 1, incrementedValue, "+ボタンを押してもcountが1増えていない")
        
        // +ボタンを複数回タップして値が正しく増えることを確認
        for _ in 0..<5 {
            incrementButton.tap()
        }
        let furtherIncrementedValue = Int(countLabel.label)
        XCTAssertEqual(currentValue! + 6, furtherIncrementedValue, "複数回タップしたときにcountが正しく増加できていない")
        
    }
}
