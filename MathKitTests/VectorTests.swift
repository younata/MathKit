//
//  VectorTests.swift
//  MathKit
//
//  Created by Rachel Brindle on 10/11/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

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
        
    }
    
    func testScalarAddition() {
        
    }
    
    func testScalarSubtraction() {
        
    }
    
    func testScalarMultiplication() {
        
    }
    
    func testAddVarByScalar() {
        
    }
    
    func testSubtractVarByScalar() {
        
    }
    
    func testMultiplyVarByScalar() {
        
    }
    
    func testVectorAddition() {
        
    }
    
    func testVectorSubtraction() {
        
    }
    
    func testVectorMultiplication() {
        
    }
    
    func testDotProduct() {
        
    }
    
    func testGradient() {
        
    }
    
    func testDivergence() {
        
    }
    
    func testCurl() {
        
    }
}
