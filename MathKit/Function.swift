//
//  Function.swift
//  MathKit
//
//  Created by Rachel Brindle on 11/2/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public protocol Function : Printable {
    var isOperator : Bool
    
    var numberOfInputs : Int
    
    func apply(terms: [Double]) -> Double
    
    func differentiate(terms: [SimplePolynomial], respectTo: String) -> Polynomial?
    
    func integrate(terms: [SimplePolynomial], respectTo: String) -> Polynomial?
}

public class Addition : Function {
    var isOperator : Bool { return true }
    var description: String { return "+" }

    var numberOfInputs : Int { return 2 }
    
    func apply(terms: [Double]) -> Double {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! + terms.last!
    }
    
    func differentiate(term: [SimplePolynomial], respectTo: String) -> Polynomial? {
        return Polynomial(SimplePolynomial: terms.first!.differentiate(respectTo) + terms.last!.differentiate(respectTo))
    }
    
    func integrate(terms: [SimplePolynomial], respectTo: String) -> Polynomial? {
        return Polynomial(SimplePolynomial: terms.first!.integrate(respectTo) + terms.last!.integrate(respectTo))
    }
}

public class Subtraction : Function {
    var isOperator : Bool { return true }
    var description: String { return "-" }
    
    var numberOfInputs : Int { return 2 }
    
    func apply(terms: [Double]) -> Double {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! - terms.last!
    }
    
    func differentiate(term: [SimplePolynomial], respectTo: String) -> Polynomial? {
        return Polynomial(SimplePolynomial: terms.first!.differentiate(respectTo) - terms.last!.differentiate(respectTo))
    }
    
    func integrate(terms: [SimplePolynomial], respectTo: String) -> Polynomial? {
        return Polynomial(SimplePolynomial: terms.first!.integrate(respectTo) - terms.last!.integrate(respectTo))
    }
}

public class Multiplication : Function {
    var isOperator : Bool { return true }
    var description: String { return "*" }
    
    var numberOfInputs : Int { return 2 }
    
    func apply(terms: [Double]) -> Double {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! * terms.last!
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo: String) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Division : Function {
    var isOperator : Bool { return true }
    var description: String { return "/" }
    
    var numberOfInputs : Int { return 2 }
    
    func apply(terms: [Double]) -> Double {
        assert(terms.count == self.numberOfInputs, "")
        return terms.first! / terms.last!
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo: String) -> Polynomial {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo: String) -> Polynomial {
        return nil
    }
}

public class Exponentiation : Function {
    var isOperator : Bool { return true }
    var description: String { return "**" }
    
    var numberOfInputs : Int { return 2 }
    
    func apply(terms: [Double]) -> Double {
        assert(terms.count == self.numberOfInputs, "")
        return pow(terms.first!, terms.last!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo: String) -> Polynomial {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo: String) -> Polynomial {
        return nil
    }
}