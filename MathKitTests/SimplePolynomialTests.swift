
//
//  SimplePolynomialTests.swift
//  MathKit
//
//  Created by Rachel Brindle on 10/11/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation
import XCTest

class SimplePolynomialTests: XCTestCase {
    
    let t0 = PolynomialTerm(coefficient: 1.0, variables: [:])
    let t1 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0])
    let t2 = PolynomialTerm(coefficient: 3.0, variables: ["x": 2.0])
    
    let y2 = PolynomialTerm(coefficient: 3.0, variables: ["y": 2.0])
    
    let mt1 = PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0, "y": 1.0])
    let mt2 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0, "y": 1.0])
    
    var p1 = SimplePolynomial()
    var p2 = SimplePolynomial()
    var p3 = SimplePolynomial()
    var p4 = SimplePolynomial()
    var p5 = SimplePolynomial()
    
    override func setUp() {
        super.setUp()
        
        p1 = SimplePolynomial(terms: [t0])
        p2 = SimplePolynomial(terms: [t1, t0])
        p3 = SimplePolynomial(terms: [mt1, y2])
        p4 = SimplePolynomial(terms: [t1, mt1, y2])
        p5 = SimplePolynomial(terms: [t2, y2])
    }
    
    // Mark: - Initialization

    func testInitializationNothing() {
        var p = SimplePolynomial()
        XCTAssertEqual(p.terms.count, 0, "should init() with nothing")
        
        p = SimplePolynomial(terms: [PolynomialTerm()])
        XCTAssertEqual(p.terms.count, 0, "should not accept terms with coefficient 0")
    }
    
    func testInitializationValid() {
        let pt = PolynomialTerm(coefficient: 1.0, variables: [:])
        
        let p = SimplePolynomial(terms: [pt])
        XCTAssertEqual(p.terms.count, 1, "should init with valid terms")
    }
    
    func testInitializationString() {
        XCTAssertEqual(SimplePolynomial(string: "1"), p1, "from string")
        XCTAssertEqual(SimplePolynomial(string: "2x + 1"), p2, "from string")
        XCTAssertEqual(SimplePolynomial(string: "(x)(y) + 3y^2"), p3, "from string")
        XCTAssertEqual(SimplePolynomial(string: "x^1y^1 + 3y^2"), p3, "from string")
        XCTAssertEqual(SimplePolynomial(string: "2x + x^1y^1 + 3y^2"), p4, "from string")
        XCTAssertEqual(SimplePolynomial(string: "3x^2 + 3y^2"), p5, "from string")
    }
    
    func testInterpolation() {
        let x2 = (x: [-1.0, 0.0, 1.0], y: [1.0, 0.0, 1.0])
        
        let interpolated = SimplePolynomial.interpolate([x2.x], output: x2.y)
        
        XCTAssertEqual(interpolated, SimplePolynomial(string: "x^2"), "interpolation")
    }

    // Mark: Info

    func testDescription() {
        XCTAssertEqual(p1.description, "f() = 1.0", "description")
        XCTAssertEqual(p2.description, "f(x) = 2.0(x) + 1.0", "description")
        XCTAssertEqual(p3.description, "f(x, y) = 3.0(y^2.0) + (x)(y)", "description")
        XCTAssertEqual(p4.description, "f(x, y) = 3.0(y^2.0) + 2.0(x) + (x)(y)", "description")
        XCTAssertEqual(p5.description, "f(x, y) = 3.0(x^2.0) + 3.0(y^2.0)", "description")
    }

    func testVariablesUsed() {
        XCTAssertEqual(p1.variables(), [], "variables")
        XCTAssertEqual(p2.variables(), ["x"], "variables")
        XCTAssertEqual(p3.variables(), ["x", "y"], "variables")
        XCTAssertEqual(p4.variables(), ["x", "y"], "variables")
        XCTAssertEqual(p5.variables(), ["x", "y"], "variables")
    }

    func testDegree() {
        XCTAssertEqual(p1.degree(), 0, "degree")
        XCTAssertEqual(p2.degree(), 1, "degree")
        XCTAssertEqual(p3.degree(), 2, "degree")
        XCTAssertEqual(p4.degree(), 2, "degree")
        XCTAssertEqual(p5.degree(), 2, "degree")
    }

    func testDimensions() {
        XCTAssertEqual(p1.dimensions(), 0, "dimensions")
        XCTAssertEqual(p2.dimensions(), 1, "dimensions")
        XCTAssertEqual(p3.dimensions(), 2, "dimensions")
        XCTAssertEqual(p4.dimensions(), 2, "dimensions")
        XCTAssertEqual(p5.dimensions(), 2, "dimensions")
    }

    // Mark: - Basic Operations

    func testEquatable() {
        XCTAssertEqual(p1, p1, "identity")
        XCTAssertEqual(p1, SimplePolynomial(terms: [t0]), "equatable")
        XCTAssertEqual(SimplePolynomial(string: "3x^2 + 3y^2"), SimplePolynomial(string: "3y^2 + 3x^2"), "commutative")
        XCTAssert(p1 == p1, "identity, overloaded operator")
    }

    func testValueAt() {
        XCTAssertEqual(p1.valueAt([:]), 1.0, "valueAt")
        XCTAssertEqual(p2.valueAt(["x": 1.0]), 3.0, "valueAt")
        XCTAssertEqual(p3.valueAt(["x": 1.0, "y": 1.0]), 4.0, "valueAt")
        XCTAssertEqual(p4.valueAt(["x": 1.0, "y": 1.0]), 6.0, "valueAt")
        XCTAssertEqual(p5.valueAt(["x": 1.0, "y": 1.0]), 6.0, "valueAt")
    }

    func testPolynomialAddition() {
        let p11 = SimplePolynomial(terms: [PolynomialTerm(coefficient: 2.0, variables: [:])])
        let p12 = SimplePolynomial(terms: [PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0]),
                                           PolynomialTerm(coefficient: 2.0, variables: [:])])
        let p13 = SimplePolynomial(terms: [mt1, y2, t0])
        let p14 = SimplePolynomial(terms: [t1, mt1, y2, t0])
        let p15 = SimplePolynomial(terms: [t2, y2, t0])

        XCTAssertEqual(p1.add(p1), p1 + p1, "overloading")
        XCTAssertEqual(p1 + p1, p11, "addition")

        XCTAssertEqual(p1 + p2, p12, "addition")
        XCTAssertEqual(p2 + p1, p12, "commutative property")

        XCTAssertEqual(p1 + p3, p13, "addition")
        XCTAssertEqual(p3 + p1, p13, "commutative property")

        XCTAssertEqual(p1 + p4, p14, "addition")
        XCTAssertEqual(p4 + p1, p14, "commutative property")

        XCTAssertEqual(p1 + p5, p15, "addition")
        XCTAssertEqual(p5 + p1, p15, "commutative property")


        let p22 = SimplePolynomial(terms: [PolynomialTerm(coefficient: 4.0, variables: ["x": 1.0]),
                                           PolynomialTerm(coefficient: 2.0, variables: [:])])
        let p23 = SimplePolynomial(terms: [t1, t0, mt1, y2])
        let p24 = SimplePolynomial(terms: [t0, mt1, y2, t1 + t1])
        let p25 = SimplePolynomial(terms: [t1, t0, t2, y2])
        XCTAssertEqual(p2 + p2, p22, "addition")

        XCTAssertEqual(p2 + p3, p23, "addition")
        XCTAssertEqual(p3 + p2, p23, "commutative property")

        XCTAssertEqual(p2 + p4, p24, "addition")
        XCTAssertEqual(p4 + p2, p24, "commutative property")

        XCTAssertEqual(p2 + p5, p25, "addition")
        XCTAssertEqual(p5 + p2, p25, "commutative property")


        let p33 = SimplePolynomial(terms: [mt2, PolynomialTerm(coefficient: 6.0, variables: ["y": 2.0])])
        let p34 = SimplePolynomial(terms: [mt2, t1, y2 + y2])
        let p35 = SimplePolynomial(terms: [mt1, t2, y2 + y2])
        XCTAssertEqual(p3 + p3, p33, "addition")

        XCTAssertEqual(p3 + p4, p34, "addition")
        XCTAssertEqual(p4 + p3, p34, "commutative property")

        XCTAssertEqual(p3 + p5, p35, "addition")
        XCTAssertEqual(p5 + p3, p35, "commutative property")

        let p44 = SimplePolynomial(terms: [t1 + t1, mt1 + mt1, y2 + y2])
        let p45 = SimplePolynomial(terms: [t1, t2, mt1, y2 + y2])
        XCTAssertEqual(p4 + p4, p44, "addition")

        XCTAssertEqual(p4 + p5, p45, "addition")
        XCTAssertEqual(p5 + p4, p45, "commutative property")

        let p55 = SimplePolynomial(terms: [t2 + t2, y2 + y2])
        XCTAssertEqual(p5 + p5, p55, "addition")
    }

    func testScalarAddition() {
        func addScalar(p: SimplePolynomial, d: Double) -> SimplePolynomial {
            return SimplePolynomial(terms: p.terms + [PolynomialTerm(coefficient: d, variables: [:])])
        }
        for p in [p1, p2, p3, p4, p5] {
            for var i = 0.0; i < 100; i++ {
                XCTAssertEqual(p + i, addScalar(p, i), "scalar addition")
            }
        }
    }

    func testPolynomialSubtraction() {
        let z = SimplePolynomial()
        XCTAssertEqual(p1 - p1, z, "identity")
        XCTAssertEqual(p2 - p2, z, "identity")
        XCTAssertEqual(p3 - p3, z, "identity")
        XCTAssertEqual(p4 - p4, z, "identity")
        XCTAssertEqual(p5 - p5, z, "identity")

        let p12 = SimplePolynomial(string: "-2x")
        let p13 = SimplePolynomial(string: "1 - (x)(y) - 3y^2")
        let p14 = SimplePolynomial(string: "1 - 2x - (x)(y) - 3y^2")
        let p15 = SimplePolynomial(string: "1 - 3x^2 - 3y^2")
        XCTAssertEqual(p1 - p2, p12, "subtraction")
        XCTAssertEqual(p1 - p3, p13, "subtraction")
        XCTAssertEqual(p1 - p4, p14, "subtraction")
        XCTAssertEqual(p1 - p5, p15, "subtraction")

        let p21 = SimplePolynomial(string: "2x")
        let p23 = SimplePolynomial(string: "2x + 1 - (x)(y) - 3y^2")
        let p24 = SimplePolynomial(string: "1 - (x)(y) - 3y^2")
        let p25 = SimplePolynomial(string: "2x + 1 - 3x^2 - 3y^2")
        XCTAssertEqual(p2 - p1, p21, "subtraction")
        XCTAssertEqual(p2 - p3, p23, "subtraction")
        XCTAssertEqual(p2 - p4, p24, "subtraction")
        XCTAssertEqual(p2 - p5, p25, "subtraction")

        let p31 = SimplePolynomial(string: "(x)(y) + 3y^2 - 1")
        let p32 = SimplePolynomial(string: "(x)(y) + 3y^2 - 2x - 1")
        let p34 = SimplePolynomial(string: "-2x")
        let p35 = SimplePolynomial(string: "(x)(y) - 3x^2")
        XCTAssertEqual(p3 - p1, p31, "subtraction")
        XCTAssertEqual(p3 - p2, p32, "subtraction")
        XCTAssertEqual(p3 - p4, p34, "subtraction")
        XCTAssertEqual(p3 - p5, p35, "subtraction")

        let p41 = SimplePolynomial(string: "2x + (x)(y) + 3y^2 - 1")
        let p42 = SimplePolynomial(string: "(x)(y) + 3y^2 - 1")
        let p43 = SimplePolynomial(string: "2x")
        let p45 = SimplePolynomial(string: "2x + (x)(y) - 3x^2")
        XCTAssertEqual(p4 - p1, p41, "subtraction")
        XCTAssertEqual(p4 - p2, p42, "subtraction")
        XCTAssertEqual(p4 - p3, p43, "subtraction")
        XCTAssertEqual(p4 - p5, p45, "subtraction")

        let p51 = SimplePolynomial(string: "3x^2 + 3y^2 - 1")
        let p52 = SimplePolynomial(string: "3x^2 + 3y^2 - 2x - 1")
        let p53 = SimplePolynomial(string: "3x^2 - (x)(y)")
        let p54 = SimplePolynomial(string: "3x^2 - 2x - (x)(y)")
        XCTAssertEqual(p5 - p1, p51, "subtraction")
        XCTAssertEqual(p5 - p2, p52, "subtraction")
        XCTAssertEqual(p5 - p3, p53, "subtraction")
        XCTAssertEqual(p5 - p4, p54, "subtraction")
    }

    func testScalarSubtraction() {
        func subtractScalar(p: SimplePolynomial, d: Double) -> SimplePolynomial {
            return SimplePolynomial(terms: p.terms + [PolynomialTerm(coefficient: -d, variables: [:])])
        }
        for p in [p1, p2, p3, p4, p5] {
            for var i = 0.0; i < 100; i++ {
                XCTAssertEqual(p - i, subtractScalar(p, i), "scalar subtraction")
            }
        }
    }

    func testPolynomialMultiplication() {
        XCTAssertEqual(p1 * p1, p1, "identity")

        let x = SimplePolynomial(string: "x")
        XCTAssertEqual(x * p1, x, "multiplication")
        XCTAssertEqual(x * p2, SimplePolynomial(string: "2x^2 + x"), "multiplication")
        XCTAssertEqual(x * p3, SimplePolynomial(string: "(x^2)(y) + 3(x)(y^2)"), "multiplication")
        XCTAssertEqual(x * p4, SimplePolynomial(string: "2x^2 + (x^2)(y) + 3(x)(y^2)"), "multiplication")
        XCTAssertEqual(x * p5, SimplePolynomial(string: "3x^3 + 3(x)(y^2)"), "multiplication")

        // TODO: more multiplication tests
    }

    func testScalarMultiplication() {
        func multScalar(p: SimplePolynomial, d: Double) -> SimplePolynomial {
            var terms : [PolynomialTerm] = []
            for t in p.terms {
                terms.append(t * d)
            }
            return SimplePolynomial(terms: terms)
        }
        for p in [p1, p2, p3, p4, p5] {
            for var i = 0.0; i < 100; i++ {
                XCTAssertEqual(p * i, multScalar(p, i), "scalar multiplication")
                XCTAssertEqual(p * i, p.multiplyDouble(i), "overloading")
            }
        }
    }

    func testScalarDivision() {
        func divideScalar(p: SimplePolynomial, d: Double) -> SimplePolynomial {
            var terms : [PolynomialTerm] = []
            for t in p.terms {
                terms.append(t / d)
            }
            return SimplePolynomial(terms: terms)
        }
        for p in [p1, p2, p3, p4, p5] {
            for var i = 1.0; i < 100; i++ {
                XCTAssertEqual(p / i, divideScalar(p, i), "scalar division")
            }
        }
    }

    func testDifferentiation() {
        XCTAssertEqual(p1.differentiate("x"), SimplePolynomial(string: "1"), "differentation")
        XCTAssertEqual(p2.differentiate("x"), SimplePolynomial(string: "2"), "differentation")

        XCTAssertEqual(p3.differentiate("x"), SimplePolynomial(string: "y"), "differentation")
        XCTAssertEqual(p3.differentiate("y"), SimplePolynomial(string: "x + 6y"), "differentation")

        XCTAssertEqual(p4.differentiate("x"), SimplePolynomial(string: "2 + y"), "differentation")
        XCTAssertEqual(p4.differentiate("y"), SimplePolynomial(string: "x + 6y"), "differentation")

        XCTAssertEqual(p5.differentiate("x"), SimplePolynomial(string: "6x"), "differentation")
        XCTAssertEqual(p5.differentiate("y"), SimplePolynomial(string: "6y"), "differentation")

        var p = SimplePolynomial(string: "4x^2y")
        XCTAssertEqual(p.differentiate("x"), SimplePolynomial(string: "8(x)(y)"), "differentiate")

        for p in [p1, p2, p3, p4, p5] {
            XCTAssertEqual(p.differentiate("a"), p, "differentation")
        }
    }

    func testGradient() {
        let p1r = Vector(polynomials: [:])
        let p2r = Vector(polynomials: ["x": SimplePolynomial(scalar: 2.0)])
        let p3r = Vector(polynomials: ["x": SimplePolynomial(string: "y"), "y": SimplePolynomial(string: "x + 6y")])
        let p4r = Vector(polynomials: ["x": SimplePolynomial(string: "y + 2"), "y": SimplePolynomial(string: "x + 6y")])
        let p5r = Vector(polynomials: ["x": SimplePolynomial(string: "6x"), "y": SimplePolynomial(string: "6y")])
        XCTAssertEqual(p1.gradient(), p1r, "gradient")
        XCTAssertEqual(p2.gradient(), p2r, "gradient")
        XCTAssertEqual(p3.gradient(), p3r, "gradient")
        XCTAssertEqual(p4.gradient(), p4r, "gradient")
        XCTAssertEqual(p5.gradient(), p5r, "gradient")
    }

    func testFindRoots() {
        let p2r = Vector(polynomials: ["x": SimplePolynomial(scalar: -0.5)])
        let res = p2.solve()
        XCTAssertGreaterThan(res.count, 0, "solve should return at least 1 result for this query")
        XCTAssertEqual(res.first!.root, p2r, "linear solve")
        XCTAssertGreaterThanOrEqual(1e-12, res.first!.error, "linear solve")
        
        let q1 = SimplePolynomial(string: "x^2 - 1")
        let q1r = q1.solve()
        XCTAssertEqual(q1r.count, 2, "quadratic solve")
        var roots : [Vector] = q1r.map { return $0.root }
        let solutions1 = [Vector(polynomials: ["x": SimplePolynomial(scalar: -1)]), Vector(polynomials: ["x": SimplePolynomial(scalar: 1)])]
        for r in solutions1 {
            XCTAssert(contains(roots, r), "quadratic solve")
        }
        
        let q2 = SimplePolynomial(string: "x^2 + 1")
        let q2r = q2.solve()
        XCTAssertEqual(q2r.count, 0, "quadratic solve")
        
        let q3 = SimplePolynomial(string: "quadratic x^2")
        let q3r = q3.solve()
        XCTAssertEqual(q3r.count, 1, "solve")
        XCTAssertEqual(q3r.first!.root, Vector(polynomials: ["x": SimplePolynomial(scalar: 0)]), "quadratic solve")
        
        let p = SimplePolynomial(string: "x^3 + 1")
        let pr = p.solve()
        XCTAssertEqual(pr.count, 1, "single dimension solve")
        XCTAssertEqual(pr.first!.root, Vector(polynomials: ["x": SimplePolynomial(scalar: -1)]), "single dimension solve")
    }
}
