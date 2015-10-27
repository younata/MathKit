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
        guard let a = self.terms.first?.simplify().terms, b = self.terms.last?.simplify().terms else { return nil }

        let terms = reducePolynomialTerms(a + b).sort()

        return Polynomial(terms: terms)
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a + b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        guard let a = self.terms.first?.differentiate(respectTo), b = self.terms.last?.differentiate(respectTo) else { return nil }
        return Polynomial(function: Addition(terms: [a, b])).simplify()
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        guard let a = self.terms.first?.integrate(respectTo), b = self.terms.last?.integrate(respectTo) else { return nil }
        return Polynomial(function: Addition(terms: [a, b])).simplify()
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
        guard let a = self.terms.first?.simplify().terms, b = self.terms.last?.simplify().terms else { return nil }

        let bTerms = b.map { $0 * -1 }
        let terms = reducePolynomialTerms(a + bTerms).sort()

        return Polynomial(terms: terms)
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a - b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        guard let a = self.terms.first?.differentiate(respectTo), b = self.terms.last?.differentiate(respectTo) else { return nil }
        return Polynomial(function: Subtraction(terms: [a, b])).simplify()
    }
    
    public func integrate(respectTo: String) -> Polynomial? {
        guard let a = self.terms.first?.integrate(respectTo), b = self.terms.last?.integrate(respectTo) else { return nil }
        print("\(Subtraction(terms: [a, b]).simplify()!)")
        return Polynomial(function: Subtraction(terms: [a, b])).simplify()
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
        guard let a = self.terms.first?.simplify().terms, b = self.terms.last?.simplify().terms else { return nil }

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
        guard let a = self.terms.first, da = a.differentiate(respectTo), b = self.terms.last, db = b.differentiate(respectTo) else { return nil }
        return ((a * db).simplify() + (b * da).simplify()).simplify()
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
        let zero = Polynomial(term: PolynomialTerm(scalar: 0))
        guard let dividend = self.terms.first?.simplify(), divisor = self.terms.last?.simplify() where divisor != zero && dividend.terms != nil && divisor.terms != nil else { return nil }
        if dividend == zero { return dividend }
        guard dividend.degree() >= divisor.degree() else { return nil }

        // polynomial long division!
        var (quotient, remainder) = (zero, dividend)
        while remainder != zero && remainder.degree() >= divisor.degree() {
            let t = Polynomial(term: remainder.terms!.first! / divisor.terms!.first!)
            (quotient, remainder) = ((quotient + t).simplify(), (remainder - (t * divisor).simplify()).simplify())
        }

        if remainder == zero { return quotient }
        return nil
    }

    public func valueAt(x: [String : Double]) -> Double? {
        guard let a = self.terms.first?.valueAt(x), b = self.terms.last?.valueAt(x) else { return nil }
        return a / b
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        guard let a = self.terms.first, da = a.differentiate(respectTo), b = self.terms.last, db = b.differentiate(respectTo) else { return nil }

        let numerator = ((b * da).simplify() - (a * db).simplify()).simplify()
        if numerator == Polynomial.zero() {
            return Polynomial.zero()
        }

        let denominator = (b ** 2).simplify()

        return (numerator / denominator).simplify()
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