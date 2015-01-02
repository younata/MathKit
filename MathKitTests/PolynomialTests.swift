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
    
    let t1 : [PolynomialTerm] = []
    let t2 : [PolynomialTerm] = []
    let t3 : [PolynomialTerm] = []
    let t4 : [PolynomialTerm] = []
    
    var p1 = Polynomial()
    var p2 = Polynomial()
    var p3 = Polynomial()
    var p4 = Polynomial()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        p1 = Polynomial(terms: t1)
        p2 = Polynomial(stack: [(t1, nil), (t2, nil), (nil, Addition())])
        p3 = Polynomial(stack: [(t2, nil), (t3, nil), (nil, Multiplication())])
        p4 = Polynomial(stack: [(t3, nil), (t4, nil), (nil, Division())])
    }
    
    func testInitializationNothing() {
        var p = Polynomial()
        // TODO
    }
    
    func testInitializationValid() {
        let pt = PolynomialTerm(coefficient: 1.0, variables: [:])
    }
    
    
}
