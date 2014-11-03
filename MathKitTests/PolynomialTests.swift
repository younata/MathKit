//
//  PolynomialTests.swift
//  MathKit
//
//  Created by Rachel Brindle on 10/11/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation
import XCTest

class PolynomialTests: XCTestCase {
    
    let sp1 = SimplePolynomial(string: "")
    let sp2 = SimplePolynomial(string: "")
    let sp3 = SimplePolynomial(string: "")
    let sp4 = SimplePolynomial(string: "")
    
    var p1 = Polynomial()
    var p2 = Polynomial()
    var p3 = Polynomial()
    var p4 = Polynomial()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        p1 = Polynomial(simplePolynomial: sp1)
        p2 = Polynomial(stack: [(sp1, nil), (sp2, nil), (nil, .Add)])
        p3 = Polynomial(stack: [(sp2, nil), (sp3, nil), (nil, .Multiply)])
        p4 = Polynomial(stack: [(sp3, nil), (sp4, nil), (nil, .Divide)])
    }
    
    func testInitializationNothing() {
        var p = Polynomial()
        XCTAssertNil(p.stack, "stack should be nil")
        XCTASsertEqual(p.terms.count, 0, "terms should be empty")
        
        p = Polynomial(terms: [PolynomialTerm()])
        XCTAssertNil(p.stack, "stack should be nil")
        XCTASsertEqual(p.terms.count, 0, "should not accept terms with coefficient 0")
        
        p = Polynomial(simplePolynomial: SimplePolynomial())
        XCTAssertNil(p.stack, "stack should be nil")
        XCTASsertEqual(p.terms.count, 0, "terms should be empty")
        
        p = Polynomial(stack: nil)
        XCTAssertNil(p.stack, "stack should be nil")
        XCTASsertEqual(p.terms.count, 0, "terms should be empty")
    }
    
    func testInitializationValid() {
        let pt = PolynomialTerm(coefficient: 1.0, variables: [:])
        
        var p = Polynomial(terms: [pt])
        XCTAssertEqual(p.terms.count, 1, "should init with valid terms")
        XCTAssertNil(p.stack, "stack should not yet be initialized")
        
        XCTAssertEqual(Polynomial(terms: [PolynomialTerm(string: "2x"), PolynomialTerm(string: "x")]), Polynomial(terms: [PolynomialTerm(string: "3x")]), "add similar terms together")
        
        p = Polynomial(simplePolynomial: sp1)
        XCTAssertEqual(p, sp1, "Initialize with simple polynomial should equal that same polynomial")
        XCTAssertNil(p.stack, "stack should not yet be initialized")
    }
    
    
}
