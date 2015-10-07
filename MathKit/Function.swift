import Foundation

public protocol Function : CustomStringConvertible {
    var isOperator : Bool { get }
    
    var numberOfInputs : Int { get }
    
    func apply(terms: [Double]) -> Double?
    
    func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial?
    
    func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial?
}

public struct Addition : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "+" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        return terms[c-2] + terms[c-1]
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        let p1 = terms[c-2].map { $0.differentiate(respectTo) }
        let p2 = terms[c-1].map { $0.differentiate(respectTo) }
        
        let ret = Polynomial(terms: p1)
        let p3 = Polynomial(terms: p2)
        ret.addPolynomial(p3)
        
        return ret
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        let p1 = terms[c-2].map { $0.integrate(respectTo) }
        let p2 = terms[c-1].map { $0.integrate(respectTo) }
        
        let ret = Polynomial(terms: p1)
        let p3 = Polynomial(terms: p2)
        ret.addPolynomial(p3)
        
        return ret
    }
}

public struct Subtraction : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "-" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        return terms[c-2] - terms[c-1]
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        let p1 = terms[c-2].map { $0.differentiate(respectTo) }
        let p2 = terms[c-1].map { $0.differentiate(respectTo) }
        
        let ret = Polynomial(terms: p1)
        let p3 = Polynomial(terms: p2)
        ret.subtractPolynomial(p3)
        
        return ret
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        let p1 = terms[c-2].map { $0.integrate(respectTo) }
        let p2 = terms[c-1].map { $0.integrate(respectTo) }
        
        let ret = Polynomial(terms: p1)
        let p3 = Polynomial(terms: p2)
        ret.subtractPolynomial(p3)
        
        return ret
    }
}

public struct Multiplication : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "*" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        return terms[c-2] * terms[c-1]
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Division : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "/" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        if terms.last! == 0 {
            return nil
        }
        let c = terms.count
        return terms[c-2] / terms[c-1]
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct Exponentiation : Function {
    public var isOperator : Bool { return true }
    public var description: String { return "**" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        return pow(terms[c-2], terms[c-1])
    }

    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}