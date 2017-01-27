//
//  FFFTestUITests.swift
//  FFFTestUITests
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest

class FFFTestUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testExample() {
        let app = XCUIApplication()
        XCUIDevice.shared().orientation = .portrait
        
        loadFirstScreenAndTapARandomCell(on: app)
        app.otherElements
            .containing(.navigationBar, identifier:"FFFTest.ImageDetailView")
            .children(matching: .other)
            .element
            .children(matching: .other)
            .element
            .children(matching: .other)
            .element
            .children(matching: .image)
            .element
            .tap()
    }
    
    private func loadFirstScreenAndTapARandomCell(on app: XCUIApplication) {
        let someRandomCell = app.collectionViews.children(matching: .cell).element(boundBy: 7)
        
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: someRandomCell, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(someRandomCell.exists)
        someRandomCell
            .otherElements
            .children(matching: .image)
            .element
            .tap()
        
    }

}
