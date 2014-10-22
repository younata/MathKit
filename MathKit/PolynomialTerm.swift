//
//  PolynomialTerm.swift
//  CFDKit
//
//  Created by Rachel Brindle on 8/12/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class PolynomialTerm: NSObject, Equatable, Comparable, Printable {
    public var coefficient : Double = 0
    public var variables : [String: Double] = [:]
    
    public override init() {
        self.coefficient = 0
        self.variables = [:]
        super.init()
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
        super.init()
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
        
        if (countElements(string) == 0) {
            PolynomialTerm()
        }
        
        let scanner = NSScanner(string: string)
        let set = NSMutableCharacterSet.letterCharacterSet()
        var coefficient = 0.0
        scanner.scanDouble(&coefficient)
        var variables : [String: Double] = [:]
        
        while (!scanner.atEnd) {
            if NSString(string: scanner.string).substringFromIndex(scanner.scanLocation).hasPrefix("(") {
                scanner.scanLocation++
            }
            var v : NSString? = NSString()
            scanner.scanCharactersFromSet(set, intoString: &v)
            if let s = v {
                if (s.length == 0) {
                    break
                }
                if NSString(string: scanner.string).substringFromIndex(scanner.scanLocation).hasPrefix("^") {
                    scanner.scanLocation++
                    var d = 0.0
                    scanner.scanDouble(&d)
                    variables[s as String] = d
                } else {
                    variables[s as String] = 1.0
                }
            } else {
                break
            }
            if NSString(string: scanner.string).substringFromIndex(scanner.scanLocation).hasPrefix(")") {
                scanner.scanLocation++
            }
        }
        
        if (variables.count != 0 && coefficient == 0.0) {
            coefficient = 1.0
        }
        
        PolynomialTerm(coefficient: coefficient, variables: variables)
        
        self.coefficient = coefficient
        self.variables = variables
    }
    
    public override var description : String {
        var str = ""
        if (self.coefficient != 1.0 || self.variables.count == 0) {
            str += "\(self.coefficient)"
        }
        var keysArray: [String] = []
        for key in self.variables.keys {
            keysArray.append(key)
        }
        let keys = keysArray.sorted { return $0 < $1 }
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
    
    public var degree : Double {
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
    
    public func equals(t : PolynomialTerm) -> Bool {
        let epsilon = 1e-6
        if (fabs(self.coefficient - t.coefficient) > epsilon) {
            return false
        }
        for key in self.variables.keys {
            let x = self.variables[key]!
            if let y = t.variables[key] {
                if (fabs(x - y) > epsilon) {
                    return false
                }
            } else {
                return false
            }
        }
        for key in t.variables.keys {
            if (self.variables[key] == nil) {
                return false
            }
        }
        return true
    }
    
    public func valueAt(x : [String : Double]) -> Double {
        var r = 1.0
        for key in self.variables.keys {
            if let d = x[key] {
                r *= pow(d, self.variables[key]!)
            } else {
                assert(false, "Can't compute the value of a polynomialTerm with unknown variables")
            }
        }
        return self.coefficient * r
    }
    
    public func add(t : PolynomialTerm) -> PolynomialTerm {
        assert(self.variables == t.variables, "Can't add two terms which don't share the same variables and exponents")
        let c = self.coefficient + t.coefficient
        
        return PolynomialTerm(coefficient: c, variables: self.variables)
    }
    
    public func subtract(t : PolynomialTerm) -> PolynomialTerm {
        assert(self.variables == t.variables, "Can't add two terms which don't share the same variables and exponents")
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
    
    public func divide(t : PolynomialTerm) -> PolynomialTerm {
        assert(t.coefficient != 0.0, "Divide by zero error")
        
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
    
    public func divideDouble(v: Double) -> PolynomialTerm {
        assert(v != 0.0, "Divide by zero error")
        
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
    
    public func gradient() -> Vector {
        let vars = self.variables.keys
        
        let sp = SimplePolynomial(terms: [self])
        
        return sp.gradient()
    }
    
    public func integrate(respectTo: String) -> PolynomialTerm {
        if let exponent = self.variables[respectTo] {
            assert(exponent != -1.0, "integrating to ln() is not supported")
            let c = self.coefficient / (exponent + 1)
            var v = self.variables
            v[respectTo] = exponent + 1
            return PolynomialTerm(coefficient: c, variables: v)
        }
        return self
    }
    
    public func integrate(respectTo: String, over: (start: Double, end: Double), spacing: Double = 0.01) -> Double {
        let start = over.start
        let end = over.end
        
        var d = 0.0
        
        for (var i = start; i <= end; i += spacing) {
            if let exponent = self.variables[respectTo] {
                let a = self.coefficient * pow(i, exponent)
                let b = self.coefficient * pow(i+spacing, exponent)
                let c = (a + b) / 2.0
                d += c * spacing
            }
        }
        
        return d
    }
    
    public func of(polynomial: SimplePolynomial, at : String) -> SimplePolynomial {
        if let exp = self.variables[at] {
            assert(exp % 1.0 == 0.0, "Can't exponentiate by floating point values")
        }
        
        return SimplePolynomial()
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
    return a.add(b)
}

public func += (inout a : PolynomialTerm, b : PolynomialTerm) {
    a = a + b
}

public func - (a : PolynomialTerm, b : PolynomialTerm) -> PolynomialTerm {
    return a.subtract(b)
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
    return a.divide(b)
}

public func /= (inout a : PolynomialTerm, b : PolynomialTerm) {
    a = a / b
}

public func / (a : PolynomialTerm, b : Double) -> PolynomialTerm {
    return a.divideDouble(b)
}

public func /= (inout a : PolynomialTerm, b : Double) {
    a = a / b
}
