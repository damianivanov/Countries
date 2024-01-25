//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Damian Ivanov on 3.01.24.
//

import XCTest

final class CountriesUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testTotalCountriesInTable() throws {

        let app = XCUIApplication()
        app.launch()

        let allCountriesButton = app.buttons["All Countries"]
        XCTAssert(allCountriesButton.exists)
        allCountriesButton.tap()

        let table = app.tables.firstMatch
        XCTAssert(table.exists)

        let expectedCount = 250
        let tableCellsCounter = table.cells.count
        XCTAssertEqual(tableCellsCounter, expectedCount, "The table does not have the expected number of cells.")
    }

    func testEmptyTextField() throws {
        let app = XCUIApplication()
        app.launch()

        let searchCountryButton = app.buttons["Search Country"]
        XCTAssert(searchCountryButton.exists)

        searchCountryButton.tap()

        let expectedAlertText = "You have to enter a country name."
        let menuText = app.staticTexts[expectedAlertText]
        XCTAssert(menuText.exists)

        let okButton = app.buttons["Ok"]
        XCTAssert(okButton.exists)
        okButton.tap()

        XCTAssert(!menuText.exists)
        XCTAssert(!okButton.exists)
    }

    func testMultipleInvalidNames() throws {

        let invalidNames = ["123", "Chinaaaa", "Bulggaria"]

        for invalidName in invalidNames {
            try testInvalidCountrySearch(invalidName)
        }
    }

    func testInvalidCountrySearch(_ invalidCountry: String) throws {
        let app = XCUIApplication()
        app.launch()

        let textField = app.textFields["Enter a country"]
        XCTAssert(textField.exists)

        textField.tap()
        textField.typeText(invalidCountry)

        let searchCountryButton = app.buttons["Search Country"]
        XCTAssert(searchCountryButton.exists)

        searchCountryButton.tap()

        let expectedAlertText = "Invalid counntry name."
        let menuText = app.staticTexts[expectedAlertText]
        XCTAssert(menuText.exists)

        let okButton = app.buttons["Ok"]
        XCTAssert(okButton.exists)
        okButton.tap()

        XCTAssert(!menuText.exists)
        XCTAssert(!okButton.exists)

    }

    func testMultipleValidNames() throws {

        let invalidNames = ["Bulgaria","Germany","France"]

        for invalidName in invalidNames {
            try testValidCountryName(invalidName)
        }
    }

    func testValidCountryName(_ validCountryName: String) throws {

        let app = XCUIApplication()
        app.launch()

        let textField = app.textFields["Enter a country"]
        XCTAssert(textField.exists)

        textField.tap()
        textField.typeText(validCountryName)

        let searchCountryButton = app.buttons["Search Country"]
        XCTAssert(searchCountryButton.exists)

        searchCountryButton.tap()

        let countryLabel = app.staticTexts[validCountryName]
        XCTAssert(countryLabel.exists)

        let scrollView  = app.scrollViews.element.images.count
        XCTAssertEqual(scrollView, 10)

        let doneButton = app.navigationBars["Countries.DetailsVC"].buttons["Done"]
        XCTAssert(doneButton.exists)
        doneButton.tap()

        XCTAssert(!app.navigationBars["Countries.DetailsVC"].exists)
    }
}
