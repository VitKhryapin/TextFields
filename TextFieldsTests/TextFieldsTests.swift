//
//  TextFieldsTests.swift
//  TextFieldsTests
//
//  Created by Vitaly Khryapin on 29.11.2021.
//

import XCTest
@testable import TextFields

class TextFieldsTests: XCTestCase {
    
    var viewTF: ViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewTF = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        viewTF.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        viewTF = nil
    }
    
    func testSignupForm_WhenLoaded_TextFieldAreConnected() throws {
        _ = try XCTUnwrap(viewTF.excludeNumberTF, "The Text to reverse UITextField is not connected")
        _ = try XCTUnwrap(viewTF.inputLimitTF, "The Text to reverse UITextField is not connected")
        _ = try XCTUnwrap(viewTF.maskTF, "The Text to reverse UITextField is not connected")
        _ = try XCTUnwrap(viewTF.linkTF, "The Text to reverse UITextField is not connected")
        _ = try XCTUnwrap(viewTF.passwordTF, "The Text to reverse UITextField is not connected")
    }

    func testExcludeNumberTF() throws {
        
        //Given
        viewTF.excludeNumberTF.text = "ad2d3 1234 1wd3s"
        let resultTest = "add  wds"
        //When
        viewTF.changedExcludeNumberTF(viewTF.excludeNumberTF)
        //Then
        XCTAssertEqual(resultTest, viewTF.excludeNumberTF.text)
    }
    
    func testInputLimitTF() throws {
        
        //Given
        viewTF.inputLimitTF.text = "12345 67890"
        let resultTest = "-1"
        //When
        viewTF.changedLimitSymbolsTF(viewTF.inputLimitTF)
        //Then
        XCTAssertEqual(resultTest, viewTF.counterCharacterLabel.text)
    }

    func testMaskTF () throws {
        
        //Given
        viewTF.maskTF.text = "qw2e3r- 67w89w0"
        let resultTest = "qwer-67890"
        //When
        viewTF.maskChanged(viewTF.maskTF)
        //Then
        XCTAssertEqual(resultTest, viewTF.maskTF.text)
    }
    
    
    func testPassTF () throws {
        
        //Given
        viewTF.passwordTF.text = "1qW23456"
        let resultTest1 = "✓ min length 8 characters."
        let resultTest2 = "✓ min 1 digit."
        let resultTest3 = "✓ min 1 lowercased."
        let resultTest4 = "✓ min 1 uppercased."
        
        //When
        viewTF.checkPassword()
        //Then
        XCTAssertEqual(resultTest2, viewTF.minNumbersLabel.text)
        XCTAssertEqual(resultTest1, viewTF.minLengthLabel.text)
        XCTAssertEqual(resultTest3, viewTF.minLowercaseLabel.text)
        XCTAssertEqual(resultTest4, viewTF.minUppercaseLabel.text)
    }
    
    
}
