//
//  PolynomialTermTests.swift
//  MathKit
//
//  Created by Rachel Brindle on 10/11/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import UIKit
import XCTest

class PolynomialTermTests: XCTestCase {
    
    let p1 = PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0])
    let p2 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0])
    
    let p3 = PolynomialTerm(coefficient: 3.0, variables: ["x": 2.0])
    let p4 = PolynomialTerm(coefficient: 4.0, variables: ["x": 2.0, "y": 1.0])

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testInitNothing() {
        let p = PolynomialTerm()
        XCTAssertEqualWithAccuracy(p.coefficient, 0.0, 1e-12, "coefficient should be zero")
        XCTAssertEqual(p.variables, [:], "coefficient variables should be empty")
    }
    
    func testInitData() {
        let c = 1.0
        let v = ["x": 1.0]
        let p = PolynomialTerm(coefficient: c, variables: v)
        XCTAssertEqualWithAccuracy(p.coefficient, c, 1e-12, "coefficient should be correctly assigned")
        XCTAssertEqual(p.variables, v, "variables should be correctly assigned")
        
        let p5 = PolynomialTerm(coefficient: 1.0, variables: ["x": 0.0])
        XCTAssertEqual(p5, PolynomialTerm(coefficient: 1.0, variables: [:]), "")
        let p6 = PolynomialTerm(coefficient: 0.0, variables: ["x": 1.0])
        XCTAssertEqual(p6, PolynomialTerm(), "")
    }
    
    func testInitString() {
        XCTAssertEqual(p1, PolynomialTerm(string: "x"), "initialize from string")
        XCTAssertEqual(p2, PolynomialTerm(string: "2x"), "initialize from string")
        XCTAssertEqual(p3, PolynomialTerm(string: "3x^2"), "initialize from string")
        //XCTAssertEqual(p4, PolynomialTerm(string, "4x^2y"), "initialize from string")
        XCTAssertEqual(PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0, "y": 1.0]), PolynomialTerm(string: "(x)(y)"), "initialize from string")
        XCTAssertEqual(PolynomialTerm(coefficient: 4.0, variables: ["str": 2.0]), PolynomialTerm(string: "4str^2"), "initialize from string")
        XCTAssertEqual(PolynomialTerm(string: ""), PolynomialTerm(), "initialize from string")
        XCTAssertEqual(PolynomialTerm(string: " "), PolynomialTerm(), "initialize from string")
        XCTAssertEqual(PolynomialTerm(string: "+"), PolynomialTerm(), "initialize from string")
        XCTAssertEqual(PolynomialTerm(string: "-"), PolynomialTerm(), "initialize from string")
    }
    
    func testPrint() {
        let p = PolynomialTerm(coefficient: 1.0, variables: [:])
        XCTAssertEqual(p.description, "1.0", "description")
        XCTAssertEqual(p1.description, "(x)", "description")
        XCTAssertEqual(p2.description, "2.0(x)", "description")
        XCTAssertEqual(p3.description, "3.0(x^2.0)", "description")
        XCTAssertEqual(p4.description, "4.0(x^2.0)(y)", "description")
    }
    
    // MARK: - Operations
    
    func testValueAt() {
        XCTAssertEqualWithAccuracy(p1.valueAt(["x": 1]), 1.0, 1e-12, "value at")
        let p5 = PolynomialTerm(coefficient: 2.4, variables: ["x": 3.5])
        XCTAssertEqualWithAccuracy(p5.valueAt(["x": 2.45]), 55.244943, 1e-6, "value at")
    }
    
    func testAdd() {
        XCTAssertEqual(p1.add(p2), PolynomialTerm(coefficient: 3.0, variables: ["x": 1.0]), "addition")
        XCTAssertEqual(p1 + p2, PolynomialTerm(coefficient: 3.0, variables: ["x": 1.0]), "addition")
    }
    
    func testSubtract() {
        XCTAssertEqual(p1.subtract(p2), PolynomialTerm(coefficient: 3.0, variables: ["x": 1.0]), "subtraction")
        XCTAssertEqual(p2.subtract(p1), PolynomialTerm(coefficient: 3.0, variables: ["x": 1.0]), "subtraction")
        
        XCTAssertEqual(p2 - p1, PolynomialTerm(coefficient: 3.0, variables: ["x": 1.0]), "subtraction")
    }
    
    func testMultiplyTerms() {
        XCTAssertEqual(p1.multiply(p2), PolynomialTerm(coefficient: 2.0, variables: ["x": 2.0]), "multiplication")
        XCTAssertEqual(p1 * p2, PolynomialTerm(coefficient: 2.0, variables: ["x": 2.0]), "multiplication")

        XCTAssertEqual(p2 * p3, PolynomialTerm(coefficient: 6.0, variables: ["x": 3.0]), "multiplication")
        XCTAssertEqual(p3 * p4, PolynomialTerm(coefficient: 12.0, variables: ["x": 4.0, "y": 1.0]), "multiplication")
        XCTAssertEqual(p2 * p4, PolynomialTerm(coefficient: 8.0, variables: ["x": 3.0, "y": 1.0]), "multiplication")
    }
    
    func testMultiplyScalar() {
        func scalarMultBehavior(a: PolynomialTerm, b: Double) -> PolynomialTerm {
            return PolynomialTerm(coefficient: a.coefficient * b, variables: a.variables)
        }
        
        for v in [p1, p2, p3, p4] {
            for var i : Double = 0.0; i < 100.0; i++ {
                XCTAssertEqual(v * i, scalarMultBehavior(v, i), "scalar multiplication")
            }
        }
    }
    
    func testDivideTerms() {
        XCTAssertEqual(p2.divide(p1), PolynomialTerm(coefficient: 2.0, variables: [:]), "division")
        XCTAssertEqual(p1.divide(p2), PolynomialTerm(coefficient: 0.5, variables: [:]), "division")
        
        XCTAssertEqual(p2 / p1, PolynomialTerm(coefficient: 2.0, variables: [:]), "division")
        XCTAssertEqual(p1 / p2, PolynomialTerm(coefficient: 0.5, variables: [:]), "division")
        
        XCTAssertEqual(p3 / p1, PolynomialTerm(coefficient: 3.0, variables: ["x": 1.0]), "division")
        XCTAssertEqual(p4 / p1, PolynomialTerm(coefficient: 4.0, variables: ["x": 1.0, "y": 1.0]), "division")
        XCTAssertEqual(p1 / p4, PolynomialTerm(coefficient: 0.25, variables: ["x": -1.0, "y": -1.0]), "division")
    }
    
    func testDivideScalar() {
        func scalarDivBehavior(a : PolynomialTerm, b : Double) -> PolynomialTerm {
            return PolynomialTerm(coefficient: a.coefficient / b, variables: a.variables)
        }
        
        for v in [p1, p2, p3, p4] {
            for var i : Double = 1.0; i < 100.0; i++ {
                XCTAssertEqual(v / i, scalarDivBehavior(v, i), "scalar division")
            }
        }
    }
    
    func testInvert() {
        XCTAssertEqual(p1.invert(), PolynomialTerm(string: "x^-1"), "inversion")
        XCTAssertEqual(p2.invert(), PolynomialTerm(string: "0.5x^-1"), "inversion")
        XCTAssertEqual(p3.invert(), PolynomialTerm(string: "x^-2") * (1.0 / 3.0), "inversion")
        XCTAssertEqual(p4.invert(), PolynomialTerm(string: "0.25(x^-2)(y^-1)"), "inversion")
    }
    
    func testDifferentiation() {
        for term in [p1, p2, p3, p4] {
            XCTAssertEqual(term.differentiate("a"), PolynomialTerm(), "differentiation")
        }
        
        XCTAssertEqual(p1.differentiate("x"), PolynomialTerm(coefficient: 1.0, variables: [:]), "differentiation")
        XCTAssertEqual(p2.differentiate("x"), PolynomialTerm(coefficient: 2.0, variables: [:]), "differentiation")
        XCTAssertEqual(p3.differentiate("x"), PolynomialTerm(coefficient: 6.0, variables: ["x": 1.0]), "differentiation")
        XCTAssertEqual(p4.differentiate("x"), PolynomialTerm(coefficient: 8.0, variables: ["x": 1.0, "y": 1.0]), "differentiation")
        XCTAssertEqual(p4.differentiate("y"), PolynomialTerm(coefficient: 4.0, variables: ["x": 2.0]), "differentiation")
    }
    
    func testGradient() {
        XCTAssertEqual(p1.gradient(), Vector(scalars: ["x": 1.0]), "gradient")
        XCTAssertEqual(p2.gradient(), Vector(scalars: ["x": 2.0]), "gradient")
    }
    
    func testIntegration() {
        XCTAssertEqual(p1.integrate("x"), p1, "integration")
        XCTAssertEqual(p1.integrate("x"), PolynomialTerm(string: "0.5x^2"), "integration")
        XCTAssertEqual(p2.integrate("x"), PolynomialTerm(string: "x^2"), "integration")
        XCTAssertEqual(p3.integrate("x"), PolynomialTerm(string: "x^3"), "integration")
        XCTAssertEqual(p4.integrate("x"), PolynomialTerm(string: "x^3y") * 4.0 / 3.0, "integration")
        XCTAssertEqual(p4.integrate("y"), PolynomialTerm(string: "2x^2y^2"), "integration")
    }
    
    func testIntegrationOverRange() {
        let r = [1.0, 2.0]
        for term in [p1, p2, p3, p4] {
            XCTAssertEqualWithAccuracy(term.integrate("a", over: r), 0.0, 1e-12, "integration")
        }
        
        XCTAssertEqualWithAccuracy(p1.integrate("x", over: r), 1.5, 1e-12, "integration")
        XCTAssertEqualWithAccuracy(p2.integrate("x", over: r), 3.0, 1e-12, "integration")
        XCTAssertEqualWithAccuracy(p3.integrate("x", over: r), 7.0, 1e-3, "integration")
        XCTAssertEqualWithAccuracy(p4.integrate("x", over: r), 9.333, 1e-3, "integration")
        XCTAssertEqualWithAccuracy(p4.integrate("y", over: r), 6.0, 1e-3, "integration")
    }
}