import Foundation

public struct Addition: Function, Equatable {
    public var description: String {
        return "(\(self.terms[0].toString)) + (\(self.terms[1].toString))"
    }

    public var latexDescription: String {
        return self.description
    }

    public var numberOfInputs: Int { return 2 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms.sort().reverse()
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        guard let a = self.terms.first?.terms, b = self.terms.last?.terms else { return nil }

        let terms = reducePolynomialTerms(a + b).sort()

        return Polynomial(terms: terms)
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a + b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        guard let a = self.terms.first?.differentiate(respectTo), b = self.terms.last?.differentiate(respectTo) else { return nil }
        return Polynomial(function: Addition(terms: [a, b]))
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}

public func ==(a: Addition, b: Addition) -> Bool {
    return a.terms == b.terms
}

public struct Subtraction: Function, Equatable {
    public var description: String {
        return "(\(self.terms[0].toString)) - (\(self.terms[1].toString))"
    }

    public var latexDescription: String {
        return self.description
    }

    public var numberOfInputs: Int { return 2 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        guard let a = self.terms.first?.terms, b = self.terms.last?.terms else { return nil }

        let bTerms = b.map { $0 * -1 }
        let terms = reducePolynomialTerms(a + bTerms).sort()

        return Polynomial(terms: terms)
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a - b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}

public func ==(a: Subtraction, b: Subtraction) -> Bool {
    return a.terms == b.terms
}

public struct Multiplication: Function, Equatable {
    public var description: String {
        return "(\(self.terms[0].toString)) * (\(self.terms[1].toString))"
    }

    public var latexDescription: String {
        return self.description
    }

    public var numberOfInputs: Int { return 2 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms.sort().reverse()
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        guard let a = self.terms.first?.terms, b = self.terms.last?.terms else { return nil }

        var ret = [PolynomialTerm]()
        for termA in a {
            for termB in b {
                ret.append(termA * termB)
            }
        }

        let terms = reducePolynomialTerms(ret).sort()

        return Polynomial(terms: terms)
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a * b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}

public func ==(a: Multiplication, b: Multiplication) -> Bool {
    return a.terms == b.terms
}

public struct Division: Function, Equatable {
    public var description: String {
        return "(\(self.terms[0].toString)) / (\(self.terms[1].toString))"
    }

    public var latexDescription: String {
        return "\\frac{(\(self.terms[0].toString))}{(\(self.terms[1].toString))}"
    }

    public var numberOfInputs: Int { return 2 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        return nil
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a / b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}

public func ==(a: Division, b: Division) -> Bool {
    return a.terms == b.terms
}

public struct Exponentiation: Function, Equatable {
    public var description: String {
        return "(\(self.terms[0].toString)) ^ (\(self.terms[1].toString))"
    }

    public var latexDescription: String {
        return "(\(self.terms[0].toString))^{(\(self.terms[1].toString))}"
    }

    public var numberOfInputs : Int { return 2 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        return nil
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return pow(a, b)
    }

    public func differentiate(respectTo: String) -> Polynomial? {
        return nil
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}

public func ==(a: Exponentiation, b: Exponentiation) -> Bool {
    return a.terms == b.terms

}