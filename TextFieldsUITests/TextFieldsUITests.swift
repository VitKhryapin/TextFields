//
//  TextFieldsUITests.swift
//  TextFieldsUITests
//
//  Created by Vitaly Khryapin on 29.11.2021.
//

import XCTest

class TextFieldsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExcludeNumberTF() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["excludeNumberTF"].tap()
        app.textFields["excludeNumberTF"].typeText("ad2d3 1234 1wd3s")
        let resultTest = "add  wds"
        XCTAssertEqual(resultTest, app.textFields["excludeNumberTF"].value as! String)
    }
    
    func testInputLimitTF() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["inputLimitTF"].tap()
        app.textFields["inputLimitTF"].typeText("1w345 67!901")
        let resultTest = app.staticTexts["counterCharacterLabel"]
        XCTAssertEqual(resultTest.label, "-2")
    }
    
    func testMaskTF() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["maskTF"].tap()
        app.textFields["maskTF"].typeText("ad2d3-123^#we45")
        let resultTest = "add-12345"
        XCTAssertEqual(resultTest, app.textFields["maskTF"].value as! String)
    }
    
    func testLinkTF() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["linkTF"].tap()
        app.textFields["linkTF"].typeText("ya.ru")
        XCTAssert(app.otherElements["URL"].waitForExistence(timeout: 5))

    }
    
    func testPasteLinkTF() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["linkTF"].tap(withNumberOfTaps: 3, numberOfTouches: 1)
        app/*@START_MENU_TOKEN@*/.staticTexts["Cut"]/*[[".menus",".menuItems[\"Cut\"].staticTexts[\"Cut\"]",".staticTexts[\"Cut\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["linkTF"].waitForExistence(timeout: 1)
        app.textFields["linkTF"].typeText("ya.ru")
        XCTAssert(app.otherElements["URL"].waitForExistence(timeout: 5))
    }
    
    func testPasswordTF() throws {
        let app = XCUIApplication()
        app.launch()
        app.secureTextFields["passwordTF"].tap()
        app.secureTextFields["passwordTF"].typeText("1qW23456")
        let resultTest1 = "✓ min length 8 characters."
        let resultTest2 = "✓ min 1 digit."
        let resultTest3 = "✓ min 1 lowercased."
        let resultTest4 = "✓ min 1 uppercased."
        XCTAssertEqual(resultTest1, app.staticTexts["minLengthLabel"].label)
        XCTAssertEqual(resultTest2, app.staticTexts["minNumbersLabel"].label)
        XCTAssertEqual(resultTest3, app.staticTexts["minLowercaseLabel"].label)
        XCTAssertEqual(resultTest4, app.staticTexts["minUppercaseLabel"].label)
    }

}
