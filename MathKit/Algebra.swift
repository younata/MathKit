//
//  Algebra.swift
//  MathKit
//
//  Created by Rachel Brindle on 11/13/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class Logarithm : Function {
    // first input is the base, second is the value.
    public var isOperator : Bool { return false }
    public var description: String { return "log" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        return log(terms.last!) / log(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class NaturalLogarithm : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "ln" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return log(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return Polynomial(stack: [([PolynomialTerm(scalar: 1)], nil), (terms.first!, nil), (nil, Division())])
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}