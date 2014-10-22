//
//  SimplePolynomial.swift
//  CFDKit
//
//  Created by Rachel Brindle on 7/16/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Accelerate
import Foundation

public class SimplePolynomial: NSObject, Equatable, Comparable, Printable/*, FloatLiteralConvertible, StringLiteralConvertible*/ {
    public var terms : [PolynomialTerm] = []
    
    public override init() {
        
    }
    
    /*
    public class func convertFromFloatLiteral(value: FloatLiteralType) -> Self {
        return self(scalar: value)
    }
    
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public class func convertFromExtendedGraphemeClusterLiteral(value: ExtendedGraphemeClusterLiteralType) -> Self {
        return self(string: value)
    }
    
    public class func convertFromStringLiteral(value: StringLiteralType) -> Self {
        return self(string: value)
    }*/
    
    required public init(scalar : Double) {
        self.terms = [PolynomialTerm(scalar: scalar)]
    }
    
    required public init(terms: [PolynomialTerm]) {
        for term in terms {
            if (term.coefficient != 0.0) {
                self.terms.append(term)
            }
        }
    }
    
    required public init(string: String) {
        let components : [String] = string.componentsSeparatedByString(" ")
        var previousArgument = ""
        for comp in components {
            if (comp == "+" || comp == "-") {
                previousArgument = comp
                continue
            }
            var t = PolynomialTerm(string: comp)
            if (previousArgument == "-") {
                t.coefficient *= -1
            }
            terms.append(t)
        }
    }
    
    public class func interpolate1Dimension(x : [Double], output : [Double]) -> SimplePolynomial {
        // create a vandermonde matrix
        var vandermonde : [Double] = []
        let n = Double(x.count)
        for m in x {
            for (var i = n; i >= 0; i--) {
                vandermonde.append(pow(Double(m), i))
            }
        }
        let len = la_count_t(n + 1)
        
        var out = output as [Double]
        let v = la_matrix_from_double_buffer(&vandermonde, len, len, 1, la_hint_t(LA_SHAPE_DIAGONAL), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let y = la_matrix_from_double_buffer(&out, len, 1, 1, la_hint_t(LA_SHAPE_DIAGONAL), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let o = la_vector_from_matrix_col(y, 0)
        let r = la_solve(v, o)
        var ret = Array(count: Int(len), repeatedValue: 0.0)
        la_vector_to_double_buffer(&ret, 1, r)
        
        var terms : [PolynomialTerm] = []
        for (var i = 0; i < Int(len); i++) {
            let idx = Int(i)
            var pt = PolynomialTerm()
            pt.coefficient = ret[idx]
            pt.variables = ["x": Double(idx)]
            terms.append(pt)
        }
        
        return SimplePolynomial(terms: terms)
    }
    
    public class func interpolate2Dimension(x : [Double], y : [Double], output : [Double]) -> SimplePolynomial {
        return SimplePolynomial()
    }
    
    public class func interpolate3Dimension(x : [Double], y : [Double], z : [Double], output : [Double]) -> SimplePolynomial {
        return SimplePolynomial()
    }
    
    public class func interpolate(input : [[Double]], output : [Double]) -> SimplePolynomial {
        assert(input.count < 4, "Interpolation of 3+ dimension polynomials is not supported")
        
        for array in input {
            assert(array.count == output.count, "Expected a 1:1 ratio of input variables to output variables")
        }
        
        switch (input.count) {
        case 1:
            return self.interpolate1Dimension(input[0], output: output)
        case 2:
            return self.interpolate2Dimension(input[0], y: input[1], output: output)
        case 3:
            return self.interpolate3Dimension(input[0], y: input[1], z: input[2], output: output)
        default:
            return SimplePolynomial()
        }
    }
    
    public override var description : String {
        var str = self.toString
        var varsUsed = self.variables()
        var v = ""
        varsUsed.sort { $0 < $1 }
        for s in varsUsed {
            if (!v.isEmpty) {
                v += ", "
            }
            v += s
        }
        return "f(" + v + ") = " + str
    }
    
    public var toString : String {
        var str = ""
        let t = self.terms.sorted({ $0 < $1 })
        
        for term in t {
            if (!str.isEmpty) {
                str += " + "
            }
            str += term.description
        }
        return str
    }
    
    public func variables() -> [String] {
        var ret : [String] = []
        for t in self.terms {
            for key in t.variables.keys {
                if (!contains(ret, key)) {
                    ret.append(key)
                }
            }
        }
        return ret.sorted { return $0 < $1 }
    }
    
    public func degree() -> Double {
        var d = 0.0
        for term in self.terms {
            d = max(d, term.degree)
        }
        return d
    }
    
    public func dimensions() -> Int {
        return self.variables().count
    }
    
    public func almostEquals (a : SimplePolynomial) -> Bool {
        if (self.dimensions() != a.dimensions()) {
            return false
        }
        if (self.degree() != a.degree()) {
            return false
        }
        
        let t1 = self.terms
        let t2 = a.terms
        
        if t1.count != t2.count {
            return false
        }
        
        for term in t1 {
            if (!contains(t2, term)) {
                return false
            }
        }
        
        return true
    }
    
    public func equals (a : SimplePolynomial) -> Bool {
        return self.almostEquals(a)
    }
    
    public func valueAt(x : [String: Double]) -> Double {
        assert(x.count == self.dimensions(), "SimplePolynomial - valueAt:, expected input.count to equal number of different variables in polygon")
        
        var ret = 0.0
        
        for term in self.terms {
            ret += term.valueAt(x)
        }
        
        return ret;
    }
    
    public func canAdd(p : SimplePolynomial) -> Bool {
        return true
    }
    
    public func add(p : SimplePolynomial) -> SimplePolynomial {
        assert(canAdd(p), "")
        var c : [PolynomialTerm] = []
        
        var variables : [String] = []
        
        for term1 in self.terms {
            let v1 = term1.variables
            var term2: PolynomialTerm? = nil
            for term in p.terms {
                if (term.variables == v1) {
                    term2 = term
                }
            }
            
            var v = term1
            if (term2 != nil) {
                v = term1 + term2!
            }
            c.append(v)
            
            var s = ""
            for key in v.variables.keys {
                s += "\(key)^\(v.variables[key])"
            }
            variables.append(s)
        }
        for term2 in p.terms {
            var s = ""
            for key in term2.variables.keys {
                s += "\(key)^\(term2.variables[key])"
            }
            
            if (!contains(variables, s)) {
                c.append(term2)
                variables.append(s)
            }
        }
        
        return SimplePolynomial(terms: c)
    }
    
    public func addDouble(v : Double) -> SimplePolynomial {
        let pt = PolynomialTerm(coefficient: v, variables: [:])
        return SimplePolynomial(terms: self.terms + [pt])
    }
    
    public func canSubtract(p : SimplePolynomial) -> Bool {
        return canAdd(p)
    }
    
    public func subtract(p : SimplePolynomial) -> SimplePolynomial {
        assert(canSubtract(p), "")
        
        var c : [PolynomialTerm] = []
        
        var variables : [String] = []
        
        for term1 in self.terms {
            let v1 = term1.variables
            var term2: PolynomialTerm? = nil
            for term in p.terms {
                if (term.variables == v1) {
                    term2 = term
                }
            }
            
            var v = term1
            if (term2 != nil) {
                v = term1 - term2!
            }
            c.append(v)
            var s = ""
            for key in v1.keys {
                s += "\(key)^\(v1[key])"
            }
            variables.append(s)
        }
        for term2 in p.terms {
            var s = ""
            for key in term2.variables.keys {
                s += "\(key)^\(term2.variables[key])"
            }
            
            if (!contains(variables, s)) {
                c.append(PolynomialTerm(coefficient: term2.coefficient * -1, variables: term2.variables))
                variables.append(s)
            }
        }
        
        return SimplePolynomial(terms: c)
    }
    
    public func subtractDouble(v: Double) -> SimplePolynomial {
        return self.addDouble(-v)
    }
    
    public func canMultiply(p : SimplePolynomial) -> Bool {
        return true
    }
    
    public func multiply(p : SimplePolynomial) -> SimplePolynomial {
        assert(canMultiply(p), "")
        var terms : [PolynomialTerm] = []
        
        for t1 in self.terms {
            for t2 in p.terms {
                let pt = t1 * t2
                var didAdd = false
                for (var i = 0; i < terms.count; i++) {
                    let t = terms[i]
                    if (t.variables == pt.variables) {
                        terms[i] = t * pt
                        didAdd = true
                        break
                    }
                }
                if (!didAdd) {
                    terms.append(pt)
                }
            }
        }
        
        return SimplePolynomial(terms: terms)
    }
    
    public func multiplyDouble(v: Double) -> SimplePolynomial {
        var terms : [PolynomialTerm] = []
        for t in self.terms {
            terms.append(t * v)
        }
        return SimplePolynomial(terms: terms)
    }
    
    public func divideDouble(v: Double) -> SimplePolynomial {
        return multiplyDouble(1.0 / v)
    }
    
    public func differentiate() -> SimplePolynomial {
        return differentiate("x")
    }
    
    public func differentiate(respectTo : String) -> SimplePolynomial { // partial derivative!
        var terms : [PolynomialTerm] = []
        
        if (!contains(variables(), respectTo)) {
            return self
        }
        
        for term in self.terms {
            terms.append(term.differentiate(respectTo))
        }
        
        return SimplePolynomial(terms: terms)
    }
    
    public func gradient() -> Vector {      
        var vars: [String: SimplePolynomial] = [:]
        
        for term in variables() {
            vars[term] = self.differentiate(term)
        }
        return Vector(polynomials: vars)
    }
    
    public func integrate(respectTo: String) -> SimplePolynomial {
        return SimplePolynomial()
    }
    
    public func integrate(respectTo: String, over: (start: Double, end: Double), spacing: Double = 0.01) -> Double {
        return 0
    }
    
    public func solve() -> [(root: Vector, error: Double)] {
        return solve(1e-6)
    }
    
    public func solve(epsilon: Double) -> [(root: Vector, error: Double)] {
        if self.dimensions() == 1 {
            var isLinear = false
            var isQuadratic = false
            let degrees = self.terms.map({$0.degree}).sorted({$0 < $1})
            let seq = [0.0, 1.0]
            let isSubset : ([Double], [Double]) -> (Bool) = {(subset: [Double], superset: [Double]) in
                for item in subset {
                    if !contains(superset, item) {
                        return false
                    }
                }
                return true
            }
            if isSubset(degrees, seq) {
                isLinear = true
            } else if isSubset(degrees, seq + [2.0]) {
                isQuadratic = true
            }
            if isQuadratic {
                let v = solveQuadratic()
                var r : [(root: Vector, error: Double)] = []
                for vec in v {
                    let e = (root: vec, error: 0.0)
                    r += [e]
                }
                return r
            } else if isLinear {
                let v = solveLinear()
                if v.count == 1 {
                    return [(root: v[0], error: 0.0)]
                }
            }
        }
        
        var x : [String: Double] = [:]
        
        var min = Double(MAXFLOAT)
        
        var i : [String: Double] = [:]
        for term in self.variables() {
            i[term] = -100.0
        }
        for term in self.variables() {
            for var n = -100.0; n <= 100.0; n+=1.0 {
                i[term] = n
                let value = abs(self.valueAt(i))
                if value < min {
                    min = value
                    x = i
                }
            }
        }
        
        let grad = self.gradient()
        var n = 0
        var y = 0
        var error = Double(MAXFLOAT)
        while true {
            if n++ > 100 { // i is incremented after the comparison is made.
                break
            }
            let delta = self.valueAt(x)// / grad.valueAt(x)
            for term in x.keys {
                x[term] = x[term]! - delta
            }
            error = abs(self.valueAt(x))
            if error < epsilon {
                break
            }
        }
        return [(root: Vector(scalars: x), error: error)]
    }
    
    public func solveLinear() -> [Vector] {
        assert(self.dimensions() == 1, "linear equation formula only works on single dimension 1 degree polynomial")
        
        var b = 0.0
        var m = 0.0
        for term in self.terms {
            assert(term.degree == 0.0 || term.degree == 1.0, "")
            if term.degree == 0.0 {
                b = term.coefficient
            } else if term.degree == 1.0 {
                m = term.coefficient
            }
        }
        
        let varname = self.variables()[0]
        
        let solution = -b / m
        
        if solution.isNaN {
            return []
        }
        
        return [Vector(polynomials: [varname: SimplePolynomial(scalar: solution)])]
    }
    
    public func solveQuadratic() -> [Vector] {
        assert(self.dimensions() == 1, "quadratic formula only works on single dimension polynomials below degree 2")
        var a = 0.0
        var b = 0.0
        var c = 0.0
        for term in self.terms {
            assert(term.degree == 0.0 || term.degree == 1.0 || term.degree == 2.0, "quadratic formula only works on single dimension polynomials below degree 2")
            if term.degree == 0.0 {
                c = term.coefficient
            } else if term.degree == 1.0 {
                b = term.coefficient
            } else if term.degree == 2.0 {
                a = term.coefficient
            }
        }
        
        let varname = self.variables()[0]
        
        let first = (-b + sqrt(pow(b, 2.0) - 4 * a * c)) / 2*a
        let second = (-b - sqrt(pow(b, 2.0) - 4 * a * c)) / 2*a
                
        if first.isNaN && second.isNaN {
            return []
        } else if first.isNaN {
            return [Vector(scalars: [varname: second])]
        } else if second.isNaN {
            return [Vector(scalars: [varname: first])]
        } else if first == second {
            return [Vector(scalars: [varname: first])]
        } else {
            return [Vector(scalars: [varname: first]), Vector(scalars: [varname: second])]
        }
    }
    
    public func of(polynomial: SimplePolynomial, at: String) -> SimplePolynomial { // returns f(g), where g is a polynomial
        return SimplePolynomial()
    }
}

public func == (a : SimplePolynomial, b : SimplePolynomial) -> Bool {
    return a.equals(b)
}

public func != (a : SimplePolynomial, b : SimplePolynomial) -> Bool {
    return !a.equals(b)
}

public func < (a : SimplePolynomial, b: SimplePolynomial) -> Bool {
    if a.dimensions() != b.dimensions() {
        return a.dimensions() < b.dimensions()
    }
    if a.degree() != b.degree() {
        return a.degree() < b.degree()
    }
    return false; // might as well be the same
}

public func + (a : SimplePolynomial, b : SimplePolynomial) -> SimplePolynomial {
    return a.add(b);
}

public func += (inout a : SimplePolynomial, b : SimplePolynomial) {
    a = a + b
}

public func + (a : SimplePolynomial, b : Double) -> SimplePolynomial {
    return a.addDouble(b)
}

public func += (inout a : SimplePolynomial, b : Double) {
    a = a + b
}

public func - (a : SimplePolynomial, b : SimplePolynomial) -> SimplePolynomial {
    return a.subtract(b)
}

public func -= (inout a : SimplePolynomial, b : SimplePolynomial) {
    a = a - b
}

public func - (a : SimplePolynomial, b : Double) -> SimplePolynomial {
    return a.subtractDouble(b)
}

public func -= (inout a : SimplePolynomial, b : Double) {
    a = a - b
}

public func * (a : SimplePolynomial, b : SimplePolynomial) -> SimplePolynomial {
    return a.multiply(b)
}

public func *= (inout a : SimplePolynomial, b : SimplePolynomial) {
    a = a * b
}

public func * (a : SimplePolynomial, b : Double) -> SimplePolynomial {
    return a.multiplyDouble(b)
}

public func *= (inout a : SimplePolynomial, b : Double) {
    a = a * b
}

/*
public func / (a : SimplePolynomial, b : SimplePolynomial) -> SimplePolynomial {
    return a.divide(b)
}

public func /= (inout a : SimplePolynomial, b : SimplePolynomial) {
    a = a / b
}
*/

public func / (a : SimplePolynomial, b : Double) -> SimplePolynomial {
    return a.divideDouble(b)
}

public func /= (inout a : SimplePolynomial, b : Double) {
    a = a / b
}
