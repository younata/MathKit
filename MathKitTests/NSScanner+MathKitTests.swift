import Foundation
import XCTest
@testable import MathKit

class NSScanner_MathKitTests: XCTestCase {

    let p = PolynomialTerm(coefficient: 2.0, variables: ["x": 2.0, "y": 1.0])

    func testScanPolynomialTermEmpty() {
        var scanner = NSScanner(string: "")
        XCTAssertNil(scanner.scanPolynomialTerm())

        scanner = NSScanner(string: "(")
        XCTAssertNil(scanner.scanPolynomialTerm())

        scanner = NSScanner(string: "(2x^2)")
        XCTAssertNil(scanner.scanPolynomialTerm())
    }

    func testScanPolynomialTerm() {
        let scanner = NSScanner(string: "2x^2y + 3")
        let res = scanner.scanPolynomialTerm()
        XCTAssert(res != nil, "scanning polynomialTerm")
        if let r = res {
            XCTAssertEqual(p, r, "scanning polynomialTerm")
        }
        XCTAssertEqual(scanner.scanLocation, 5, "scanning polynomialTerm")
    }

    func testScanPolynomialTermParens() {
        let scanner = NSScanner(string: "(x)(y) + 3")
        let res = scanner.scanPolynomialTerm()
        XCTAssert(res != nil, "scanning polynomialTerm")
        if let r = res {
            XCTAssertEqual(PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0, "y": 1.0]), r, "scanning polynomialTerm")
        }
        XCTAssertEqual(scanner.scanLocation, 6, "scanning polynomialTerm")
    }

    func testScanPolynomialTermNegative() {
        let scanner = NSScanner(string: "-x + 3")
        let res = scanner.scanPolynomialTerm()
        XCTAssert(res != nil, "scanning polynomialTerm")
        if let r = res {
            XCTAssertEqual(PolynomialTerm(coefficient: -1.0, variables: ["x": 1.0]), r, "scanning polynomialTerm")
        }
        XCTAssertEqual(scanner.scanLocation, 2, "scanning polynomialTerm")
    }

    func testScanPolynomialEmpty() {
        let scanner = NSScanner(string: "")
        let p = scanner.scanPolynomial()
        XCTAssertNil(p)
    }

    func testScanPolynomialSimple() {
        let scanner = NSScanner(string: "-(y)(x) + 3")
        let res = scanner.scanPolynomial()
        XCTAssertNotNil(res)
        if let r = res {
            XCTAssertEqual(r, Polynomial(terms: [PolynomialTerm(string: "-(x)(y)"), PolynomialTerm(scalar: 3)]))
        }
        XCTAssertEqual(scanner.scanLocation, 11)
        XCTAssert(scanner.atEnd)
    }

    func testScanPolynomialComplex() {
        let scanner = NSScanner(string: "(-(y)(x) + 3) / (x + 1)")
        let res = scanner.scanPolynomial()
        XCTAssertNotNil(res)
        if let r = res {
            let numerator = Polynomial(terms: [PolynomialTerm(string: "-(x)(y)"), PolynomialTerm(scalar: 3)])
            let denominator = Polynomial(terms: [PolynomialTerm(string: "x"), PolynomialTerm(scalar: 1)])
            XCTAssertEqual(r, Polynomial(function: Division(terms: [numerator, denominator])))
        }
        XCTAssertEqual(scanner.scanLocation, 23)
        XCTAssert(scanner.atEnd)
    }
}