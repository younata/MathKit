import Foundation

// Sin, Cos, Tan
// inverse (arc) of above
// hyperbolic of above

public struct Sine : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "sin" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return sin(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Cosine : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "cos" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return cos(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Tangent : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "tan" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return tan(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcSine : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "asin" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return asin(terms.last!)
    }

    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcCos : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "acos" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return acos(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcTangent : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "atan" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return atan(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcTangent2 : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "atan2" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? { // y, x
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        return atan2(terms[c-2], terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Sinh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "sinh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return sinh(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Cosh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "cosh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return cosh(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Tanh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "tanh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return tanh(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcSinh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "asinh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return asinh(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcCosh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "acosh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return acosh(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct ArcTanh : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "atanh" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return atanh(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}
