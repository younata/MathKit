//
//  PolynomialTermPerformance.swift
//  MathKit
//
//  Created by Rachel Brindle on 10/22/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Cocoa
import XCTest

class PolynomialTermPerformance: XCTestCase {
    
    let p1 = PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0])
    let p2 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0])
    
    let p3 = PolynomialTerm(coefficient: 3.0, variables: ["x": 2.0])
    let p4 = PolynomialTerm(coefficient: 4.0, variables: ["x": 2.0, "y": 1.0])
    
    func testInitStringPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                PolynomialTerm(string: "4x^2y")
            }
        }
    }
    
    func testValueAtPerformance() {
        let p5 = PolynomialTerm(coefficient: 2.4, variables: ["x": 3.5])
        self.measureBlock {
            for i in 0..<1000 {
                p5.valueAt(["x": 2.45])
            }
        }
    }
    
    func testAddPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p1 + self.p2
            }
        }
    }
    
    func testSubtractPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p2 - self.p1
            }
        }
    }
    
    func testMultiplyTermsPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 * self.p2
            }
        }
    }
    
    func testMultiplyScalarPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 * 30.0
            }
        }
    }
    
    func testDivideTermsPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 / self.p1
            }
        }
    }
    
    func testDivideScalarPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 / 30.0
            }
        }
    }
    
    func testInvertPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.invert()
            }
        }
    }
    
    func testDifferentiationPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.differentiate("x")
            }
        }
    }
    
    func testIntegrationPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.integrate("x")
            }
        }
    }
    
    func testIntegrationOverRangePerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.integrate("x", over: [1.0, 2.0])
            }
        }
    }
}
