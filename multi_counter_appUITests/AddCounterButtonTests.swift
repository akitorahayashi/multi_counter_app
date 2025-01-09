//
//  AddCounterButtonTests.swift
//  multi_counter_app
//
//  Created by 林 明虎 on 2025/01/09.
//

import XCTest

class AddCounterButtonTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // テストが失敗しても他のテストケースを続行
        continueAfterFailure = true
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAddCounterButtonAddsNewCell() throws {
        // Arrange
        let tableView = app.tables["CounterTableView"]
        let addCounterButton = app.buttons["Add Counter"]
        let initialCellCount = tableView.cells.count
        let expectedCellCount = initialCellCount + 1
        // Act
        addCounterButton.tap()
        // Assert
        XCTAssertEqual(tableView.cells.count, expectedCellCount)
        // 新しいCellが正しいデフォルト値を持っていることを確認
        let newCell = tableView.cells.element(boundBy: initialCellCount)
        let countLabelInNewCell = newCell.staticTexts.matching(identifier: "CounterOfThisCell").element
        let initialCount = Int(countLabelInNewCell.label)
        XCTAssertEqual(initialCount, 0, "新しいセルのデフォルトのcountが0で設定されていない")
    }
}
