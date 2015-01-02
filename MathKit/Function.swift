//
//  Function.swift
//  MathKit
//
//  Created by Rachel Brindle on 11/2/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public protocol Function : Printable {
    var isOperator : Bool { get }
    
    var numberOfInputs : Int { get }
    
    func apply(terms: [Double]) -> Double?
    
    func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial?
    
    func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial?
}

public class Addition : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "+" }

    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! + terms.last!
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil//Polynomial(simplePolynomial: terms.first!.differentiate(respectTo)! + terms.last!.differentiate(respectTo)!)
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil//Polynomial(simplePolynomial: terms.first!.integrate(respectTo)! + terms.last!.integrate(respectTo)!)
    }
}

public class Subtraction : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "-" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! - terms.last!
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil//Polynomial(simplePolynomial: terms.first!.differentiate(respectTo)! - terms.last!.differentiate(respectTo)!)
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil//Polynomial(simplePolynomial: terms.first!.integrate(respectTo)! - terms.last!.integrate(respectTo)!)
    }
}

public class Multiplication : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "*" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! * terms.last!
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Division : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "/" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        assert(terms.count == self.numberOfInputs, "")
        if terms.last! == 0 {
            return nil
        }
        return terms.first! / terms.last!
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Exponentiation : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "**" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        assert(terms.count == self.numberOfInputs, "")
        return pow(terms.first!, terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}