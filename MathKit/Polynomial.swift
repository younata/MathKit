import Foundation

// Polynomial is just a special kind of tree with function and lists of PolynomialTerms...

public protocol Function: CustomStringConvertible, LatexStringConvertable {
    var terms: [Polynomial] { get }
    var numberOfInputs: Int { get }

    init(terms: [Polynomial])

    func simplify() -> Polynomial?
    func valueAt(x: [String : Double]) -> Double?
    func differentiate(respectTo: String) -> Polynomial?
    func integrate(respectTo: String) -> Polynomial?
}

public struct Polynomial: Equatable, Comparable, CustomStringConvertible, LatexStringConvertable { // TODO: add Comparable
    
    internal var function: Function? = nil
    internal var terms: [PolynomialTerm]? = nil

    public init() {
        self = Polynomial.zero()
    }

    public init(term: PolynomialTerm) {
        self.init(terms: [term])
    }

    public init(terms: [PolynomialTerm]) {
        let t = reducePolynomialTerms(terms)
        if t.isEmpty {
            self.terms = [PolynomialTerm(scalar: 0)]
        } else {
            self.terms = t
        }
    }

    public init(function: Function) {
        self.function = function
    }
    
    public init(scalar: Double) {
        self.init(term: PolynomialTerm(scalar: scalar))
    }

    public init(string: String) {
        let scanner = NSScanner(string: string)
        if let poly = scanner.scanPolynomial() {
            self = poly
        }
    }

    public static func zero() -> Polynomial {
        return Polynomial(scalar: 0)
    }

    public static func one() -> Polynomial {
        return Polynomial(scalar: 1)
    }

    public static func interpolate(input: [[Double]], output: [Double]) -> Polynomial? {
        return nil; // FIXME: implement interpolation
    }

    public var description: String {
        var varsUsed = self.variables()
        var v = ""
        varsUsed.sortInPlace { $0 < $1 }
        for s in varsUsed {
            if (!v.isEmpty) {
                v += ", "
            }
            v += s
        }
        return "f(\(v)) = \(self.toString)"
    }

    public var latexDescription: String {
        return ""
    }
    
    public func equals(p: Polynomial) -> Bool {
        return self.description == p.description // FIXME: This is a terrible way to do comparisons.
    }
    
    private func termsString(terms: [PolynomialTerm]) -> String {
        var str = ""
        let t = terms.sort({ $0 < $1 })
        
        for term in t {
            if (!str.isEmpty) {
                str += " + "
            }
            str += term.description
        }
        return str
    }
    
    internal var toString : String {
        func termsToString(terms: [PolynomialTerm]) -> String {
            var str = ""
            for (idx, term) in terms.enumerate() {
                str += term.description
                if idx < (terms.count - 1) {
                    str += " + "
                }
            }
            return str
        }
        if let function = self.function {
            if let simplified = function.simplify() {
                return simplified.toString
            } else {
                return function.description
            }
        } else if let terms = self.terms {
            return termsToString(terms)
        }
        return ""
    }
    
    public func variables() -> [String] {
        if let function = self.function {
            let allVariables = function.terms.reduce([String]()) { $0 + $1.variables() }
            return Array(Set(allVariables)).sort { $0 < $1 }
        } else if let terms = self.terms {
            let allVariables = terms.reduce([String]()) { $0 + $1.variableNames() }
            return Array(Set(allVariables)).sort { $0 < $1 }
        }
        return []
    }
    
    public func degree() -> Double {
        if let function = self.function {
            if let simplified = function.simplify() {
                return simplified.degree()
            } else {
                return function.terms.reduce(0) { max($0, $1.degree()) }
            }
        } else if let terms = self.terms {
            return terms.reduce(0) { max($0, $1.degree) }
        }
        return 0
    }

    public func simplify() -> Polynomial {
        if let fnSimplified = self.function?.simplify() {
            return fnSimplified
        } else if let terms = self.terms {
            return Polynomial(terms: reducePolynomialTerms(terms))
        }
        return self
    }
    
    public func valueAt(x: [String : Double]) -> Double? {
        if let function = self.function {
            return function.valueAt(x)
        } else if let terms = self.terms {
            var ret = 0.0
            for term in terms {
                if let value = term.valueAt(x) {
                    ret += value
                } else {
                    return nil
                }
            }
            return ret
        }
        return nil
    }
    
    public func polynomialAt(at: [String: Double]) -> Polynomial {
        return Polynomial() // TODO: Implement polynomial at certain variables.
    }
    
    public func polynomialComposition(at: [String: Polynomial]) -> Polynomial {
        return Polynomial() // TODO: Implement polynomial at certain polynomials.
    }

    public func addPolynomial(p : Polynomial) -> Polynomial {
        return Polynomial(function: Addition(terms: [self, p])).simplify()
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {
        return Polynomial(function: Subtraction(terms: [self, p])).simplify()
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {
        return Polynomial(function: Multiplication(terms: [self, p])).simplify()
    }
    
    public func dividePolynomial(p : Polynomial) -> Polynomial {
        return Polynomial(function: Division(terms: [self, p])).simplify()
    }
    
    public func exponentiatePolynomial(p : Polynomial) -> Polynomial {
        return Polynomial(function: Exponentiation(terms: [self, p])).simplify()
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        if let function = self.function {
            return function.differentiate(respectTo)
        } else if let terms = self.terms {
            let newTerms = terms.reduce([PolynomialTerm]()) {
                let a = $1.differentiate(respectTo)
                if a != PolynomialTerm(scalar: 0) {
                    return $0 + [a]
                }
                return $0
            }

            return Polynomial(terms: newTerms)
        }
        return nil
    }

    public func integrate(respectTo: String) -> Polynomial? {
        if let function = self.function {
            return function.integrate(respectTo)
        } else if let terms = self.terms {
            let newTerms = terms.reduce([PolynomialTerm]()) {
                return $0 + [$1.integrate(respectTo)]
            }
            return Polynomial(terms: newTerms)
        }
        return nil
    }
    
    public func gradient() -> Vector? {
        return Vector(polynomials: self.variables().reduce([:]) {(dict: [String: Polynomial], variable: String) in
            var ret = dict
            ret[variable] = self.differentiate(variable)
            return ret
        })
    }
}

public func ==(a: Polynomial, b: Polynomial) -> Bool {
    return a.equals(b)
}

public func <(a: Polynomial, b: Polynomial) -> Bool {
    return a.degree() < b.degree()
}

public func >(a: Polynomial, b: Polynomial) -> Bool {
    return a.degree() > b.degree()
}

public func +(a: Polynomial, b: Polynomial) -> Polynomial {
    return a.addPolynomial(b);
}

public func +=(inout a: Polynomial, b: Polynomial) {
    a = a + b
}

public func +(a: Polynomial, b: Double) -> Polynomial {
    return a.addPolynomial(Polynomial(scalar: b))
}

public func +=(inout a: Polynomial, b: Double) {
    a = a + b
}

public func -(a: Polynomial, b: Polynomial) -> Polynomial {
    return a.subtractPolynomial(b)
}

public func -=(inout a: Polynomial, b: Polynomial) {
    a = a - b
}

public func -(a: Polynomial, b: Double) -> Polynomial {
    return a.subtractPolynomial(Polynomial(scalar: b))
}

public func -=(inout a: Polynomial, b: Double) {
    a = a - b
}

public func *(a: Polynomial, b: Polynomial) -> Polynomial {
    return a.multiplyPolynomial(b)
}

public func *=(inout a: Polynomial, b: Polynomial) {
    a = a * b
}

public func *(a: Polynomial, b: Double) -> Polynomial {
    return a.multiplyPolynomial(Polynomial(scalar: b))
}

public func *=(inout a: Polynomial, b: Double) {
    a = a * b
}

public func /(a: Polynomial, b: Polynomial) -> Polynomial {
    return a.dividePolynomial(b)
}

public func /=(inout a: Polynomial, b: Polynomial) {
    a = a / b
}

public func /(a: Polynomial, b: Double) -> Polynomial {
    return a.dividePolynomial(Polynomial(scalar: b))
}

public func /=(inout a: Polynomial, b: Double) {
    a = a / b
}

public func **(a: Polynomial, b: Double) -> Polynomial {
    return a.exponentiatePolynomial(Polynomial(scalar: b))
}

public func **=(inout a: Polynomial, b: Double) {
    a = a ** b
}

public func **(a: Polynomial, b: Polynomial) -> Polynomial {
    return a.exponentiatePolynomial(b)
}

public func **=(inout a: Polynomial, b: Polynomial) {
    a = a ** b
}
