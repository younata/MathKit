import Foundation
import XCTest

class VectorTests: XCTestCase {
    
    let v1 = Vector(polynomials: ["x": SimplePolynomial(string: "2x + 1")])
    let v2 = Vector(polynomials: ["x": SimplePolynomial(string: "2x + y")])
    let v3 = Vector(polynomials: ["x": SimplePolynomial(string: "2x + 1"), "y": SimplePolynomial(string: "2x + 1")])
    let v4 = Vector(polynomials: ["x": SimplePolynomial(string: "2x + 1"), "y": SimplePolynomial(string: "2x + y")])

    override func setUp() {
        super.setUp()
    }
    
    func testInitScalars() {
        let v = Vector(scalars: ["x": 1.0])
        XCTAssertEqual(v.variables, ["x": SimplePolynomial(scalar: 1.0)], "init scalars")
    }
    
    func testInitPolynomials() {
        let p = SimplePolynomial(scalar: 1.0)
        let v = Vector(polynomials: ["x": p])
        XCTAssertEqual(v.variables, ["x": SimplePolynomial(scalar: 1.0)], "init polynomials")
        XCTAssertEqual(v.variables, ["x": p], "init polynomials")
    }
    
    func testEquality() {
        XCTAssert(v1.isEqual(Vector(polynomials: ["x": SimplePolynomial(string: "2x + 1")])), "equality")
        XCTAssert(v1.isEqual(v1), "identity")
        XCTAssertEqual(v1.isEqual(v1), v1 == v1, "overloading")
        XCTAssertNotEqual(v1, v2, "inequality")
        XCTAssertNotEqual(v1, v3, "inequality")
    }
    
    func testDescription() {
        XCTAssertEqual(v1.description, "x: f(x) = 2.0(x) + 1.0\n", "description")
        XCTAssertEqual(v2.description, "x: f(x, y) = 2.0(x) + (y)\n", "description")
        XCTAssertEqual(v3.description, "x: f(x) = 2.0(x) + 1.0\ny: f(x) = 2.0(x) + 1.0\n", "description")
        XCTAssertEqual(v4.description, "x: f(x) = 2.0(x) + 1.0\ny: f(x, y) = 2.0(x) + (y)\n", "description")
    }
    
    let p = SimplePolynomial(string: "2x + y")
    let p1 = SimplePolynomial(string: "2x + 1")
    
    func testScalarAddition() {
        XCTAssertEqual(v1 + p, v1.scalarAddition(p), "overloading")
        XCTAssertEqual(v1 + p, Vector(polynomials: ["x": SimplePolynomial(string: "4x + y + 1")]), "scalar addition")
        
        XCTAssertEqual(v4 + p, Vector(polynomials: ["x": SimplePolynomial(string: "4x + y + 1"), "y": SimplePolynomial(string: "4x + 2y")]), "scalar addition")
    }
    
    func testScalarSubtraction() {
        XCTAssertEqual(v1 - p, v1.scalarSubtraction(p), "overloading")
        XCTAssertEqual(v1 - p, Vector(polynomials: ["x": SimplePolynomial(string: "1 - y")]), "scalar subtraction")
        
        XCTAssertEqual(v4 - p, Vector(polynomials: ["x": SimplePolynomial(string: "1 - y"), "y": SimplePolynomial()]), "scalar subtraction")
    }
    
    func testScalarMultiplication() {
        XCTAssertEqual(v1 * v2, v1.scalarMultiplication(p), "overloading")
        XCTAssertEqual(v1 * p, Vector(polynomials: ["x": SimplePolynomial(string: "4x^2 + 2(x)(y) + 2x + y")]), "scalar multiplication")
        
        XCTAssertEqual(v4 * p, Vector(polynomials: ["x": SimplePolynomial(string: "4x^2 + 2(x)(y) + 2x + y"), "y": p * p]), "scalar multiplication")
    }
    
    func testAddVarByScalar() {
        XCTAssertEqual(v3.addScalar(p, to: "x"), Vector(polynomials: ["x": p + p1, "y": p1]), "add scalar")
    }
    
    func testSubtractVarByScalar() {
        XCTAssertEqual(v3.subtractScalar(p, from: "x"), Vector(polynomials: ["x": p1 - p, "y": p1]), "subtract scalar")
    }
    
    func testMultiplyVarByScalar() {
        XCTAssertEqual(v3.multiplyScalar(p, on: "x"), Vector(polynomials: ["x": p1 * p, "y": p1]), "multiply scalar")
    }
    
    func testVectorAddition() {
        XCTAssertEqual(v1.vectorAddition(v2), v2.vectorAddition(v1), "commutative")
        XCTAssertEqual(v1 + v2, v1.vectorAddition(v2), "overloading")
        XCTAssertEqual(v1 + v2, Vector(polynomials: ["x": SimplePolynomial(string: "4x + y + 1")]), "vector addition")
    }
    
    func testVectorSubtraction() {
        XCTAssertNotEqual(v1.vectorSubtraction(v2), v2.vectorSubtraction(v1), "shouldn't be commutative")
        XCTAssertEqual(v1 - v2, v1.vectorSubtraction(v2), "overloading")
        XCTAssertEqual(v2 - v1, Vector(polynomials: ["x": SimplePolynomial(string: "y - 1")]), "vector subtraction")
    }
    
    func testVectorMultiplication() {
        XCTAssertEqual(v1.vectorMultiplication(v2), v2.vectorMultiplication(v1), "commutative")
        XCTAssertEqual(v1 * v2, v1.vectorMultiplication(v2), "overloading")
        XCTAssertEqual(v1 * v2, Vector(polynomials: ["x": SimplePolynomial(string: "4x^2 + 2x + y + 2(x)(y)")]), "vector multiplication")
    }
    
    func testDotProduct() {
        XCTFail("dot product")
    }
    
    func testGradient() {
        XCTFail("gradient for vector fields")
    }
    
    func testDivergence() {
        XCTFail("divergence for vector fields")
    }
    
    func testCurl() {
        XCTFail("curl for vector fields")
    }
}
