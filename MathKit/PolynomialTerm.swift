import Foundation

public struct PolynomialTerm: Equatable, Comparable, CustomStringConvertible, LatexStringConvertable {
    public var coefficient : Double = 0
    public var variables : [String: Double] = [:]

    public init() {
        self.coefficient = 0
        self.variables = [:]
    }

    public init(coefficient : Double, variables : [String : Double]) {
        self.coefficient = coefficient

        self.variables = [:]

        if (coefficient != 0.0) {
            for key in variables.keys {
                if (variables[key] != 0.0) {
                    self.variables[key] = variables[key]
                }
            }
        }
    }

    public init(scalar : Double) {
        self.variables = [:]
        self.coefficient = scalar
    }

    public init(string : String) {
        // input is of form 2xy^2 == 2 * xy^2
        // can do multichar variable names with
        // 2x^1y^1z^2 == 2 * xyz^2
        // terms of form x*2 are invalid.

        let scanner = NSScanner(string: string)
        if let term = scanner.scanPolynomialTerm() {
            self.coefficient = term.coefficient
            self.variables = term.variables
        }
    }
    
    public var description: String {
        var str = ""
        if (self.coefficient != 1.0 || self.variables.count == 0) {
            str += "\(self.coefficient)"
        }
        var keysArray: [String] = []
        for key in self.variables.keys {
            keysArray.append(key)
        }
        let keys = keysArray.sort { return $0 < $1 }
        for key in keys {
            let v = self.variables[key]!
            str += "(\(key)"
            if (v != 1.0) {
                str += "^" + "\(v)"
            }
            str += ")"
        }
        return str
    }

    public var latexDescription: String {
        return ""
    }
    
    public var degree: Double {
        var ret = 0.0;
            for v in self.variables.keys {
                ret = max(ret, self.variables[v]!)
            }
            
            return ret
    }
    
    public var dimensions : Int {
        return variables.count
    }
    
    public func variableNames() -> [String] {
        var ret : [String] = []
        for term in self.variables.keys {
            ret.append(term)
        }
        return ret
    }
    
    /**
    Tests for equality
    
    This scales at O(n^2) worst case (n is number of variables in each term)
    
    - parameter term: The PolynomialTerm this is being compared to
    
    - returns: A boolean based on whether or not t and self are equivalent
    */
    public func equals(term : PolynomialTerm) -> Bool {
        let epsilon = 1e-6
        if (fabs(self.coefficient - term.coefficient) > epsilon) {
            return false
        }
        for key in self.variables.keys {
            let x = self.variables[key]!
            if let y = term.variables[key] {
                if (fabs(x - y) > epsilon) {
                    return false
                }
            } else {
                return false
            }
        }
        for key in term.variables.keys {
            if (self.variables[key] == nil) {
                return false
            }
        }
        return true
    }
    
    // MARK: - Evaluating
    
    /**
    Evaluates the term at a given point
    
    Note that all variables in the term must be supplied for this to work. Else, use termAt:
    
    Scales at O(n), where n is the number of terms.
    
    - parameter x: A dictionary of variables to (double) values to plug in.
    
    - returns: The value of the term at the given point.
    */
    public func valueAt(x : [String : Double]) -> Double? {
        var r = 1.0
        for key in self.variables.keys {
            if let d = x[key] {
                r *= pow(d, self.variables[key]!)
            } else {
                print("Can't compute the value of a polynomialTerm with unknown variables")
                return nil
            }
        }
        return self.coefficient * r
    }
    
    /**
    Evaluates the term at a given point
    
    Scales at O(n), where n is the number of terms
    
    - parameter x: A dictionary of variables to (double) values to plug in.
    
    - returns: A reduced term with the input'd variables exponentiated and multiplied. E.G. 2x^2y^2 at ["x": 2] returns 8y^2
    */
    public func termAt(x: [String: Double]) -> PolynomialTerm {
        var vars = self.variables
        var c = self.coefficient
        for key in x.keys {
            let d = x[key]!
            if let val = vars[key] {
                vars.removeValueForKey(key)
                c *= pow(d, val)
            }
        }
        return PolynomialTerm(coefficient: c, variables: vars)
    }
    
    public func of(terms: [PolynomialTerm], at : String) -> [PolynomialTerm] {
        if let power = self.variables[at] {
            return terms.map {(term: PolynomialTerm) in
                let c = pow(term.coefficient, power) * self.coefficient
                var vars = term.variables
                for key in vars.keys {
                    let normalPower = vars[key]!
                    vars[key] = normalPower * power
                }
                return PolynomialTerm(coefficient: c, variables: vars)
            }
        }
        return [self]
    }
    
    // MARK: - Operations
    
    public func add(t : PolynomialTerm) -> PolynomialTerm? {
        if self.variables != t.variables {
            return nil
        }
        let c = self.coefficient + t.coefficient
        
        return PolynomialTerm(coefficient: c, variables: self.variables)
    }
    
    public func subtract(t : PolynomialTerm) -> PolynomialTerm? {
        if self.variables != t.variables {
            return nil
        }
        let c = self.coefficient - t.coefficient
        
        return PolynomialTerm(coefficient: c, variables: self.variables)
    }
    
    public func multiply(t : PolynomialTerm) -> PolynomialTerm {
        let c = self.coefficient * t.coefficient
        
        var d : [String : Double] = [:]
        
        for v in self.variables.keys {
            let e1 = self.variables[v]!
            if let e2 = t.variables[v] {
                d[v] = e1 + e2
            } else {
                d[v] = e1
            }
        }
        for v in t.variables.keys {
            if d[v] == nil {
                d[v] = t.variables[v]
            }
        }
        
        return PolynomialTerm(coefficient: c, variables: d)
    }
    
    public func multiplyDouble(v : Double) -> PolynomialTerm {
        return PolynomialTerm(coefficient: self.coefficient * v, variables: self.variables)
    }
    
    public func exponentiate(power : Double) -> PolynomialTerm {
        let c = pow(coefficient, power)
        var v : [String : Double] = [:]
        for key in variables.keys {
            let exponent = variables[key]! * power
            v[key] = variables[key]! * power
        }
        return PolynomialTerm(coefficient: c, variables: v)
    }
    
    public func divide(t : PolynomialTerm) -> PolynomialTerm? {
        if t.coefficient == 0.0 {
            return nil
        }
        let c = self.coefficient / t.coefficient
        
        var d : [String : Double] = [:]
        
        for v in self.variables.keys {
            let e1 = self.variables[v]!
            if let e2 = t.variables[v] {
                d[v] = e1 - e2
            } else {
                d[v] = e1
            }
        }
        for v in t.variables.keys {
            if d[v] == nil {
                d[v] = -1 * t.variables[v]!
            }
        }
        
        return PolynomialTerm(coefficient: c, variables: d)
    }
    
    public func divideDouble(v: Double) -> PolynomialTerm? {
        if v == 0.0 {
            return nil
        }
        
        return self.multiplyDouble(1.0 / v)
    }
    
    public func invert() -> PolynomialTerm {
        var vars : [String: Double] = [:]
        for v in self.variableNames() {
            if let d = self.variables[v] {
                vars[v] = -d
            }
        }
        return PolynomialTerm(coefficient: 1.0 / self.coefficient, variables: vars)
    }
    
    public func differentiate(respectTo : String) -> PolynomialTerm {
        if (self.degree == 0.0) {
            return PolynomialTerm()
        }
        
        if let d = self.variables[respectTo] {
            var v = self.variables
            v[respectTo] = d - 1.0
            return PolynomialTerm(coefficient: d * self.coefficient, variables: v)
        } else {
            return PolynomialTerm()
        }
    }
    
    public func gradient() -> Vector? {
        let vars = self.variables.keys
        
        let p = Polynomial(terms: [self])
        
        return p.gradient()
    }
    
    public func integrate(respectTo: String) -> PolynomialTerm {
        if let exponent = self.variables[respectTo] {
            assert(exponent != -1.0, "integrating to ln() is not supported")
            let c = self.coefficient / (exponent + 1)
            var v = self.variables
            v[respectTo] = exponent + 1
            return PolynomialTerm(coefficient: c, variables: v)
        } else {
            var vars = self.variables
            vars[respectTo] = 1.0
            return PolynomialTerm(coefficient: self.coefficient, variables: vars)
        }
    }
    
    public func integrate(respectTo: String, over: (start: Double, end: Double)) -> PolynomialTerm {
        let integrated = integrate(respectTo)
        return integrated.termAt([respectTo: over.end]) - integrated.termAt([respectTo: over.start])
    }
}

public func == (a : PolynomialTerm, b : PolynomialTerm) -> Bool {
    return a.equals(b)
}

public func != (a : PolynomialTerm, b : PolynomialTerm) -> Bool {
    return !a.equals(b)
}

public func < (a : PolynomialTerm, b : PolynomialTerm) -> Bool {
    if (a.degree != b.degree) {
        return a.degree > b.degree
    }
    if (a.dimensions != b.dimensions) {
        return a.dimensions < b.dimensions
    }
    return a.coefficient > b.coefficient
}

public func + (a : PolynomialTerm, b : PolynomialTerm) -> PolynomialTerm {
    return a.add(b)!
}

public func += (inout a : PolynomialTerm, b : PolynomialTerm) {
    a = a + b
}

public func - (a : PolynomialTerm, b : PolynomialTerm) -> PolynomialTerm {
    return a.subtract(b)!
}

public func -= (inout a : PolynomialTerm, b : PolynomialTerm) {
    a = a - b
}

public func * (a : PolynomialTerm, b : PolynomialTerm) -> PolynomialTerm {
    return a.multiply(b)
}

public func *= (inout a : PolynomialTerm, b : PolynomialTerm) {
    a = a * b
}

public func * (a : PolynomialTerm, b : Double) -> PolynomialTerm {
    return a.multiplyDouble(b)
}

public func *= (inout a : PolynomialTerm, b : Double) {
    a = a * b
}

public func / (a : PolynomialTerm, b : PolynomialTerm) -> PolynomialTerm {
    return a.divide(b)!
}

public func /= (inout a : PolynomialTerm, b : PolynomialTerm) {
    a = a / b
}

public func / (a : PolynomialTerm, b : Double) -> PolynomialTerm {
    return a.divideDouble(b)!
}

public func /= (inout a : PolynomialTerm, b : Double) {
    a = a / b
}

public func ** (a : PolynomialTerm, b : Double) -> PolynomialTerm {
    return a.exponentiate(b)
}

public func **= (inout a : PolynomialTerm, b : Double) {
    a = a ** b
}
