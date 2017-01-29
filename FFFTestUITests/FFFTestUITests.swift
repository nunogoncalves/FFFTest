//
//  FFFTestUITests.swift
//  FFFTestUITests
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest

class FFFTestUITests: XCTestCase {
        
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testExample() {
        XCUIDevice.shared().orientation = .portrait
     
        testGalleryScreenAndTapARandomCell()
        testImageDetailsScreen()
    }
    
    private func testGalleryScreenAndTapARandomCell() {
        
        searchUserNamePhotos()
        
        let cells = app.collectionViews.children(matching: .cell)
        let someRandomCell = cells.element(boundBy: 7)
        
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: someRandomCell, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(someRandomCell.exists)
        
        XCTAssert(cells.count > 20, "expected to have more than 20 cells") //this is not great because it actually depends on the user... should have a way to inject fake user/photos here...
        
        someRandomCell.tap()
    }
    
    private func searchUserNamePhotos() {
        let userSearchField = app.searchFields["Search for a user (ex: Almsaeed)"]
        XCTAssertNotNil(userSearchField)
        
        userSearchField.tap()
        userSearchField.typeText("Almsaeed")
        app.buttons["Search"].tap()
    }
    
    private func testImageDetailsScreen() {
        app.navigationBars["FFFTest.ImageDetailsView"].buttons["Flickr Fotos"].tap()
    }

}
