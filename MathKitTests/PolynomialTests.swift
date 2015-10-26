import Foundation
import XCTest
@testable import MathKit

class PolynomialTests: XCTestCase {
    
    let t1 : [PolynomialTerm] = [PolynomialTerm(string: "2x"), PolynomialTerm(string: "1")]
    let t2 : [PolynomialTerm] = [PolynomialTerm(string: "0.5x^2"), PolynomialTerm(string: "2")]
    let t3 : [PolynomialTerm] = [PolynomialTerm(string: "3x"), PolynomialTerm(string: "3")]
    let t4 : [PolynomialTerm] = [PolynomialTerm(string: "x"), PolynomialTerm(string: "4")]

    var p1 = Polynomial()
    var p2 = Polynomial()
    var p3 = Polynomial()
    var p4 = Polynomial()

    override func setUp() {
        super.setUp()

        let pt2 = Polynomial(terms: t2)
        let pt3 = Polynomial(terms: t3)
        let pt4 = Polynomial(terms: t4)

        p1 = Polynomial(terms: t1)
        p2 = Polynomial(function: Addition(terms: [p1, pt2]))
        p3 = Polynomial(function: Multiplication(terms: [pt2, pt3]))
        p4 = Polynomial(function: Division(terms: [pt3, pt4]))
    }

    func testInitializationNothing() {
        XCTAssertEqual(Polynomial(terms: []), Polynomial(term: PolynomialTerm(scalar: 0)))
    }

    func testInitializationFunction() {
        let pt2 = Polynomial(terms: t2)
        XCTAssertEqual(p2, Polynomial(function: Addition(terms: [p1, pt2])))
    }

    func testInitializationString() {
        XCTAssertEqual(Polynomial(string: "2x + 1"), p1, "string initalization")
        XCTAssertEqual(Polynomial(string: "(2x + 1) + (0.5x^2 + 2)"), p2, "string initialization")
        XCTAssertEqual(Polynomial(string: "0.5x^2 + 2x + 3"), p2, "string initialization, compressing")
        XCTAssertEqual(Polynomial(string: "(0.5x^2 + 2) * (3x + 3)"), p3, "string initialization")
        XCTAssertEqual(Polynomial(string: "1.5x^3 + 1.5x^2 + 6x + 6"), p3, "string initialization, compressing")
        XCTAssertEqual(Polynomial(string: "(3x + 3) / (x + 4)"), p4, "string initialization")
    }

    func test1DInterpolation() {
        XCTFail("1d interpolation")
    }

    func test2DInterpolation() {
        XCTFail("2d interpolation")
    }

    func test3DInterpolation() {
        XCTFail("3d interpolation")
    }

    func testArbitraryDimensionInterpolation() {
        XCTFail("n-dimension interpolation")
    }

    // Mark: Info
    func testComparable() {
        let pt2 = Polynomial(terms: t2)
        let pt3 = Polynomial(terms: t3)
        let pt4 = Polynomial(terms: t4)

        XCTAssertGreaterThan(pt2, p1)
        XCTAssertFalse(pt2 < p1)

        let p = Polynomial(term: PolynomialTerm(string: "1"))

        XCTAssertGreaterThan(p1, p)

        XCTAssertLessThanOrEqual(pt3, pt4)
        XCTAssertGreaterThanOrEqual(pt3, pt4)
        XCTAssertFalse(pt3 < pt4)
        XCTAssertFalse(pt3 > pt4)
        XCTAssert(pt3 != pt4)
    }

    func testDescription() {
        XCTAssertEqual(p1.description, "f(x) = 2.0(x) + 1.0", "description")
        XCTAssertEqual(p2.description, "f(x) = 0.5(x^2.0) + 2.0(x) + 3.0", "description")
        XCTAssertEqual(p3.description, "f(x) = 1.5(x^3.0) + 1.5(x^2.0) + 6.0(x) + 6.0", "description")
        XCTAssertEqual(p4.description, "f(x) = (3.0(x) + 3.0) / ((x) + 4.0)", "description")
    }

    func testVariablesUsed() {
        for p in [p1, p2, p3, p4] {
            XCTAssertEqual(p.variables(), ["x"], "variables")
        }
        // TODO: better test variables
    }

    func testDegree() {
        XCTAssertEqual(p1.degree(), 1, "degree")
        XCTAssertEqual(p2.degree(), 2, "degree")
        XCTAssertEqual(p3.degree(), 3, "degree")
        XCTAssertEqual(p4.degree(), 1, "degree")
    }

    // Mark: Operations

    func testEquatable() {
        XCTAssertEqual(p1, p1, "identity")
        XCTAssertEqual(p1, Polynomial(string: "2x + 1"), "equatable")
        XCTAssert(p1 == p1, "identity, overloaded operator")
    }

    func testSimplify() {
        XCTAssertEqual(p2.simplify(), Polynomial(terms: (t1 + t2).sort()))
    }

    func testValueAt() {
        for x in -10..<10 where x != -4 {
            let p1v = p1.valueAt(["x": Double(x)])
            let p2v = p2.valueAt(["x": Double(x)])
            let p3v = p3.valueAt(["x": Double(x)])
            let p4v = p4.valueAt(["x": Double(x)])

            let d = Double(x)

            let t1a = Double((2 * x) + 1)
            let t2a = Double((0.5 * pow(d, 2)) + 2)
            let t3a = Double((3 * x) + 3)
            let t4a = Double(x + 4)

            let p1a = t1a
            let p2a = t1a + t2a
            let p3a = t2a * t3a
            let p4a = t3a / t4a

            XCTAssertNotNil(p1v, "valueAt")
            XCTAssertNotNil(p2v, "valueAt")
            XCTAssertNotNil(p3v, "valueAt")
            XCTAssertNotNil(p4v, "valueAt")
            if p1v != nil { XCTAssertEqualWithAccuracy(p1v!, p1a, accuracy: 1e-6, "valueAt") }
            if p2v != nil { XCTAssertEqualWithAccuracy(p2v!, p2a, accuracy: 1e-6, "valueAt") }
            if p3v != nil { XCTAssertEqualWithAccuracy(p3v!, p3a, accuracy: 1e-6, "valueAt") }
            if p4v != nil { XCTAssertEqualWithAccuracy(p4v!, p4a, accuracy: 1e-6, "valueAt") }
        }
    }

    func testPolynomialAt() {
        XCTFail("PolynomialAt")
    }

    func testPolynomialComposition() {
        XCTFail("Composition")
    }

    func testAddition() {
        XCTAssertEqual(p1 + Polynomial(terms: t2), p2, "Addition")
        XCTFail("Addition")
    }

    func testSubtraction() {
        XCTAssertEqual(p2 - Polynomial(terms: t2), p1, "Subtraction")
        XCTFail("Subtraction")
    }

    func testMultiplication() {
        XCTAssertEqual(Polynomial(terms: t2) * Polynomial(terms: t3), p3, "Multiplication")
        XCTFail("Multiplication")
    }

    func testDivision() {
        XCTAssertEqual(Polynomial(terms: t3) / Polynomial(terms: t4), p4, "Division")
        XCTFail("Division")
    }

    func testExponentiation() {
//        XCTAssertEqual(Polynomial(string: "3x + 4") ** Polynomial(string: "2x + 1"), Polynomial(string: "(3x + 4) ** (2x + 1)"), "Exponentiation")
        XCTFail("Exponentiation")
    }

    func testDifferentiation() {
        let a = PolynomialTerm(string: "0.5x^2")
        let b = PolynomialTerm(string: "3x")
        let c = PolynomialTerm(scalar: 1)

        let parent = Polynomial(terms: [a, b, c])
        XCTAssertNotNil(parent.differentiate("a"))
        let expectedDifferentiated = Polynomial(term: PolynomialTerm(scalar: 0))
        XCTAssertEqual(parent.differentiate("a"), expectedDifferentiated)

        let p = parent.differentiate("x")

        XCTAssertNotNil(p, "Differentiation")
        if p != nil {
            let d = PolynomialTerm(string: "x")
            let e = PolynomialTerm(scalar: 3)
            XCTAssertEqual(p!, Polynomial(terms: [d, e]), "Differentiation")
        }
    }

    func testGradient() {
        XCTFail("Gradient")
    }

    func testIntegration() {
        //XCTAssertEqual(Polynomial(string: "0.5x^2 + 3x + 1").differentiate("x"), Polynomial(string: "x + 3"), "Differentiation")
        XCTFail("Integration")
    }

    func testIntegrationOverRange() {
        XCTFail("Integration Over Range")
    }

    func testFindRoots() {
        XCTFail("Find Roots")
    }
}
