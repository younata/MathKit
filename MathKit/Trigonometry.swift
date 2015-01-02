//
//  Trigonometry.swift
//  MathKit
//
//  Created by Rachel Brindle on 11/3/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

// Sin, Cos, Tan
// inverse (arc) of above
// hyperbolic of above

public class Sine : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "sin" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return sin(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Cosine : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "cos" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return cos(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Tanget : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "tan" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return tan(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcSine : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "asin" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return asin(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcCos : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "acos" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return acos(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcTangent : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "atan" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return atan(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcTangent2 : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "atan2" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? { // y, x
        return atan2(terms.first!, terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Sinh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "sinh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return sinh(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Cosh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "cosh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return cosh(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class Tanh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "tanh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return tanh(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcSinh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "asinh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return asinh(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcCosh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "acosh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return acosh(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public class ArcTanh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "atanh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        return atanh(terms.first!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}
