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
    
    // 名前を追加したり更新したりをアラートを通じてできるかテストする関数
    func testCounterNameChangeReflectsInView() {
        let tableView = app.tables["CounterTableView"]
        let defaultCell = tableView.cells.element(boundBy: 0)
        defaultCell.tap()
        // alertとtextfieldとsaveButtonを取得
        let nameChangeAlert = app.alerts.matching(identifier: "NameChangeAlert").element
        let nameChangeTextfield = nameChangeAlert.textFields.matching(identifier: "NameChangeTextField").element
        let saveButton = nameChangeAlert.buttons.matching(identifier: "SaveButton").element
        
        // Act: counterに名前を追加する
        let newName = "New Counter Name"
        nameChangeTextfield.tap()
        nameChangeTextfield.typeText(newName)
        saveButton.tap()
        // Assert
        let nameLabel = defaultCell.staticTexts.matching(identifier: "CounterCellName").element
        XCTAssertEqual(nameLabel.label, newName)
        
        // Act: counterの名前を更新する
        defaultCell.tap()
        let secondName = "New Counter Name2"
        nameChangeTextfield.tap()
        nameChangeTextfield.typeText("2")
        saveButton.tap()
        // Assert
        XCTAssertEqual(nameLabel.label, secondName)
    }
    // + ボタンの機能をテストする関数
    func testIncrementButtonWorks() throws {
        let tableView = app.tables["CounterTableView"]
        // セルの中のボタンを取得
        let defaultCell = tableView.cells.element(boundBy: 0)
        let incrementButton = defaultCell.buttons["+"]
        // セルに紐づいている現在値を取得
        let countLabel = defaultCell.staticTexts.matching(identifier: "CounterOfThisCell").element
        let currentValue = Int(countLabel.label)
        
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
    
    // - ボタンの機能をテストする関数
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
    
    // Counterを削除できるかテストする関数
    func testCounterCellDeletion() {
        let tableView = app.tables["CounterTableView"]
        let initialCellCount = tableView.cells.count
        let defaultCell = tableView.cells.element(boundBy: 0)
        // セルを左にスワイプして削除ボタンを表示
        defaultCell.swipeLeft()
        // 削除ボタンが存在するか確認
                let deleteButton = defaultCell.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "左にスワイプしてもDeleteボタンが出現しなかった")
        deleteButton.tap()
        // セルが削除されたことを確認
        let finalCellCount = tableView.cells.count
        XCTAssertEqual(finalCellCount, initialCellCount - 1, "セルは正しく削除されていない")
    }
}
