//
//  SMMathTests.swift
//  SMMathTests
//
//  Created by Alexey Siginur on 19/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

import XCTest
@testable import SMMath

class SMMathTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testTemp() {
		XCTAssertEqual(5,	SMMath.calculate(formula: "1 + $max(3, 1) + 1"))
	}

    func testStandart() {
		XCTAssertEqual(-44,	SMMath.calculate(formula: "(10 + (2   * 6)) (-2) + (0)"))
		XCTAssertEqual(206,	SMMath.calculate(formula: "(100 * 2 + 12)+3(-2)1"))
		XCTAssertEqual(310,	SMMath.calculate(formula: "(-32) + (-9) (23 - (1 + 2 ((0 + 5) * (6))))"))
		XCTAssertEqual(9,	SMMath.calculate(formula: "(6 + (100 * ( ((-2) + 12) * 7 ) / (14 * 1)) % 3 * 3 +-6) % (4 * (3 + 7) / 2)"))
		XCTAssertEqual(1,	SMMath.calculate(formula: "4 + -3"))
		XCTAssertEqual(-5,	SMMath.calculate(formula: "3 * -4 % 50 + 1"))
		XCTAssertEqual(-9,	SMMath.calculate(formula: "3 * -3 ( -100 + 101 )"))
		XCTAssertEqual(6,	SMMath.calculate(formula: "-2 ( 3 / -1 )"))
		XCTAssertEqual(83,	SMMath.calculate(formula: "23 - (12 - -3)* -4"))
		XCTAssertEqual(1,	SMMath.calculate(formula: "(2 + 3) - 4"))
		XCTAssertEqual(-7,	SMMath.calculate(formula: "5 + -4 (2 + 1)"))
		XCTAssertEqual(-18,	SMMath.calculate(formula: "9 (-2 + 1)2"))
		XCTAssertEqual(-36,	SMMath.calculate(formula: "9(-2)2"))
    }
	
	func testVariables() {
		XCTAssertEqual(11,	SMMath.calculate(formula: "a + b - 2", data: ["a": 10, "b": 3]))
		XCTAssertEqual(4,	SMMath.calculate(formula: "(9 / a) + b - 2", data: ["a": 3, "b": 3]))
	}
	
	func testMaxFunction() {
		XCTAssertEqual(6,	SMMath.calculate(formula: "1 + $max(1, 2) + 3"))
		XCTAssertEqual(6,	SMMath.calculate(formula: "3 + $max(a, b) + 1", data: ["a": 2, "b": 1]))
		XCTAssertEqual(13,	SMMath.calculate(formula: "3 + $max(a, $max(9, c)) + 1", data: ["a": 2, "b": 1, "c": 6]))
	}
	
	func testMinFunction() {
		XCTAssertEqual(5,	SMMath.calculate(formula: "1 + $min(1, 2) + 3"))
		XCTAssertEqual(5,	SMMath.calculate(formula: "3 + $min(a, b) + 1", data: ["a": 2, "b": 1]))
		XCTAssertEqual(6,	SMMath.calculate(formula: "3 + $min(a, $min(9, c)) + 1", data: ["a": 2, "b": 1, "c": 6]))
	}
	
	func testCombinedFunctions() {
		XCTAssertEqual(6,	SMMath.calculate(formula: "3 + $min(a, $max(9, c)) + 1", data: ["a": 2, "b": 1, "c": 6]))
		XCTAssertEqual(10,	SMMath.calculate(formula: "3 + $max(a, $min(9, c)) + 1", data: ["a": 2, "b": 1, "c": 6]))
	}

}
