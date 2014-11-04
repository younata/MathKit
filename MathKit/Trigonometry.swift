//
//  Trigonometry.swift
//  MathKit
//
//  Created by Rachel Brindle on 11/3/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class Sine : Function {
    var isOperator : Bool { return false }
    var description: String { return "sin" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return sin(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class Cosine : Function {
    var isOperator : Bool { return false }
    var description: String { return "cos" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return cos(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class Tanget : Function {
    var isOperator : Bool { return false }
    var description: String { return "tan" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return tan(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcSine : Function {
    var isOperator : Bool { return false }
    var description: String { return "asin" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return asin(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcCos : Function {
    var isOperator : Bool { return false }
    var description: String { return "acos" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return acos(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcTangent : Function {
    var isOperator : Bool { return false }
    var description: String { return "atan" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return atan(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcTangent2 : Function {
    var isOperator : Bool { return false }
    var description: String { return "atan2" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? { // y, x
        return atan2(terms.first!, terms.last!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class Sinh : Function {
    var isOperator : Bool { return false }
    var description: String { return "sinh" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return sinh(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class Cosh : Function {
    var isOperator : Bool { return false }
    var description: String { return "cosh" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return cosh(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class Tanh : Function {
    var isOperator : Bool { return false }
    var description: String { return "tanh" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return tanh(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcSinh : Function {
    var isOperator : Bool { return false }
    var description: String { return "asinh" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return asinh(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcCosh : Function {
    var isOperator : Bool { return false }
    var description: String { return "acosh" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return acosh(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}

public class ArcTanh : Function {
    var isOperator : Bool { return false }
    var description: String { return "atanh" }
    
    var numberOfInputs : Int { return 1 }
    
    func apply(terms: [Double]) -> Double? {
        return atanh(terms.first!)
    }
    
    func differentiate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
    
    func integrate(terms: [SimplePolynomial], respectTo) -> Polynomial? {
        return nil
    }
}
