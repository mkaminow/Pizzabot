//
//  PizzabotTests.swift
//  PizzabotTests
//
//

import XCTest
@testable import Pizzabot


class PizzabotTest: XCTestCase {

    let pizzabot = Pizzabot()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPostiveCase() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "5x5 (1, 3) (4, 4)"), "ENNNDEEEND")
    }

    func testMissingInput() {
        XCTAssertEqual(pizzabot.deliverPizza(input: ""), errorStringNoInput)
    }

    func testNoSize() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "(1, 3) (4, 4)"), "ENNNDEEEND")
    }

    func testLetterCoordinates() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "5x5 (a, c) (4,4)"), "EEEENNNND")
    }

    func testExtraSpaces() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "5 x5 (1 , 3) ( 4, 4)"), "ENNNDEEEND")
    }

    func test3DCoordinate() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "5x5 (1 , 3, 4) ( 4, 4)"), "EEEENNNND")
    }

    func testCoordinatesOutsideBounds() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "2x2 (1, 3) (4, 4)"), "")
    }

    func testCoordinatesMissingCoordinateValues() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "5x5 ( , ) (4, 4)"), "EEEENNNND")
    }

    func testShortRouteThatNearestNeighborCannotSolve() {
        XCTAssertEqual(pizzabot.deliverPizza(input: "5x5 (1, 1) (0, 4) (4, 1)"), "NNNNDESSSDEEED")
    }

    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
