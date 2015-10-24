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

    public init() {}

    public init(term: PolynomialTerm) {
        self.init(terms: [term])
    }

    public init(terms: [PolynomialTerm]) {
        self.terms = reducePolynomialTerms(terms)
    }

    public init(function: Function) {
        self.function = function
    }
    
    public init(scalar: Double) {
        self.init(term: PolynomialTerm(scalar: scalar))
    }

    public init(string: String) {

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
        return Polynomial(function: Addition(terms: [self, p]))
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {
        return Polynomial(function: Subtraction(terms: [self, p]))
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {
        return Polynomial(function: Multiplication(terms: [self, p]))
    }
    
    public func dividePolynomial(p : Polynomial) -> Polynomial {
        return Polynomial(function: Division(terms: [self, p]))
    }
    
    public func exponentiatePolynomial(p : Polynomial) -> Polynomial {
        return Polynomial(function: Exponentiation(terms: [self, p]))
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
//        var stack = self.stack
//        var ret : [Polynomial] = []
//        while (stack.count > 0) {
//            var polys : [[PolynomialTerm]] = []
//            var theFunction : Function? = nil
//            while true {
//                if stack.count == 0 {
//                    break
//                }
//                let a = stack.removeAtIndex(0)
//                if let p = a.polynomial {
//                    polys.append(p)
//                } else if let o = a.op {
//                    theFunction = o
//                    break
//                } else {
//                    return nil
//                }
//            }
//            if let function = theFunction {
//                assert(function.numberOfInputs == polys.count, "")
//                if let res = function.differentiate(polys, respectTo: respectTo) {
//                    ret.append(res)
//                } else {
//                    return nil
//                }
//            } else {
//                return nil
//            }
//        }
        // FIXME: do stuff with ret to create a polynomial
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
