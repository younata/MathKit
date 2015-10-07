import Foundation

public struct Logarithm : Function {
    // first input is the base, second is the value.
    public var isOperator : Bool { return false }
    public var description: String { return "log" }
    
    public var numberOfInputs : Int { return 2 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        let c = terms.count
        return log(terms.last!) / log(terms[c-2])
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}

public struct NaturalLogarithm : Function {
    public var isOperator : Bool { return false }
    public var description: String { return "ln" }
    
    public var numberOfInputs : Int { return 1 }
    
    public func apply(terms: [Double]) -> Double? {
        if terms.count < self.numberOfInputs {
            return nil
        }
        return log(terms.last!)
    }
    
    public func differentiate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return Polynomial(stack: [([PolynomialTerm(scalar: 1)], nil), (terms.first!, nil), (nil, Division())])
    }
    
    public func integrate(terms: [[PolynomialTerm]], respectTo: String) -> Polynomial? {
        return nil
    }
}