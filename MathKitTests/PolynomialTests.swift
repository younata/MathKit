import Foundation
import XCTest

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
        p1 = Polynomial(terms: t1)
        p2 = Polynomial(stack: [(t1, nil), (t2, nil), (nil, Addition())])
        p3 = Polynomial(stack: [(t2, nil), (t3, nil), (nil, Multiplication())])
        p4 = Polynomial(stack: [(t3, nil), (t4, nil), (nil, Division())])
    }

    func testInitializationNothing() {
        var p = Polynomial()
        XCTAssertEqual(p.stack.count, 0, "should init() with empty stack")

        p = Polynomial(stack: [])
        XCTAssertEqual(p.stack.count, 0, "should init() with empty array if given that")

        p = Polynomial(terms: [PolynomialTerm()])
        XCTAssertEqual(p.stack.count, 0, "should not accept terms with coefficient 0")
    }

    func testInitializationValid() {
        let pt = PolynomialTerm(coefficient: 1.0, variables: [:])

        let p = Polynomial(terms: [pt])
        XCTAssertEqual(p.stack.count, 1, "should init() with valid terms")

        XCTAssertEqual(Polynomial(terms: [PolynomialTerm(string: "2x"), PolynomialTerm(string: "x")]), Polynomial(terms: [PolynomialTerm(string: "3x")]), "Should automatically add similar terms together")
    }

    func testInitializationCompressing() {
        XCTAssertEqual(p2, Polynomial(terms: t1 + t2), "Compressing Initialization")
        XCTAssertEqual(p3, Polynomial(terms: [PolynomialTerm(string: "1.5x^3"), PolynomialTerm(string: "1.5x^2"), PolynomialTerm(string: "6x"), PolynomialTerm(string: "6")]), "Compressing Initialization")
    }

    func testInitializationString() {
//        XCTAssertEqual(Polynomial(string: "2x + 1"), p1, "string initalization")
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

    func testDescription() {
        XCTAssertEqual(p1.description, "f(x) = 2.0(x) + 1.0", "description")
        XCTAssertEqual(p2.description, "f(x) = 0.5(x^2) + 2.0(x) + 3.0", "description")
        XCTAssertEqual(p3.description, "f(x) = 1.5(x^3.0) + 1.5(x^2.0) + 6.0(x) + 6.0", "description")
        XCTAssertEqual(p4.description, "f(x) = (3.0(x) + 3.0) / (x + 4.0)", "description")
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

    func testValueAt() {
        for x in -10..<10 {
            let p1v = p1.valueAt(["x": Double(x)])
            let p2v = p2.valueAt(["x": Double(x)])
            let p3v = p3.valueAt(["x": Double(x)])
            let p4v = p4.valueAt(["x": Double(x)])

            let d = Double(x)

            let t1a = Double(2 * x + 1)
            let t2a = Double(1.5 * pow(d, 2) + 2)
            let t3a = Double(3 * x + 3)
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
        let p = Polynomial(string: "0.5x^2 + 3x + 1").differentiate("x")
        XCTAssertNotNil(p, "Differentiation")
        if p != nil {
            XCTAssertEqual(p!, Polynomial(string: "x + 3"), "Differentiation")
        }
        XCTFail("Differentiation")
    }

    func testGradient() {
        // blep.
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
