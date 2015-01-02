//
//  Polynomial.swift
//  CFDKit
//
//  Created by Rachel Brindle on 8/14/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class Polynomial : NSObject, Equatable, Printable { // TODO: add Comparable
    
    var stack : [(polynomial: [PolynomialTerm]?, op: Function?)] = []
        
    public override init() {
        super.init()
    }
    
    public convenience init(terms: [PolynomialTerm]) {
        self.init(stack: [(terms, nil)])
    }

    public init(polynomial : Polynomial) {
        super.init()
        stack = polynomial.stack
    }
    
    public init(stack: [(polynomial: [PolynomialTerm]?, op: Function?)]) {
        super.init()
        self.stack = stack
    }
    
    public convenience init(scalar: Double) {
        self.init(terms: [PolynomialTerm(scalar: scalar)])
    }
    
    public convenience init(string: String) {
        self.init(terms: [])
    }
    
    public class func interpolate(input: [[Double]], output: [Double]) -> Polynomial? {
        return nil; // FIXME: implement interpolation
    }
    
    public override func copy() -> AnyObject {
        return Polynomial(stack: stack)
    }
    
    public override var description : String {
        var varsUsed = self.variables()
        var v = ""
        varsUsed.sort { $0 < $1 }
        for s in varsUsed {
            if (!v.isEmpty) {
                v += ", "
            }
            v += s
        }
        return "f(\(v)) = \(self.toString)"
    }
    
    public func equals(p: Polynomial) -> Bool {
        return false
    }
    
    private func termsString(terms: [PolynomialTerm]) -> String {
        var str = ""
        let t = terms.sorted({ $0 < $1 })
        
        for term in t {
            if (!str.isEmpty) {
                str += " + "
            }
            str += term.description
        }
        return str
    }
    
    private var toString : String {
        var str = ""
        while (stack.count > 0) {
            var polys : [[PolynomialTerm]] = []
            polys.append(stack.removeAtIndex(0).polynomial!)
            var theFunction : Function? = nil
            while true {
                if stack.count == 0 {
                    break
                }
                let a = stack.removeAtIndex(0)
                if let p = a.polynomial {
                    polys.append(p)
                } else {
                    theFunction = a.op
                    break
                }
            }
            if let function = theFunction {
                let c = polys.count - 1
                assert(function.numberOfInputs <= polys.count, "Expected the number of inputs to function to be less than or equal to the number of polynomials available.")
                if function.isOperator && function.numberOfInputs == 2 {
                    if polys.count == 2 {
                        str += "(\(termsString(polys[c-1]))) \(function.description) (\(termsString(polys[c])))"
                    } else {
                        str += "(\(function.description) (\(termsString(polys.last!)))"
                    }
                } else {
                    str = function.description + "(" + str
                    str += "\(function.description)("
                    for (i, p) in enumerate(polys) {
                        str += "\(termsString(p))"
                        if i != (polys.count - 1) {
                            str += ", "
                        }
                    }
                    str += ") "
                }
                for (var i = 0; i < (c - function.numberOfInputs); i++) {
                    stack.insert((polys[i], nil), atIndex: 0)
                }
            } else {
                str += polys.reduce("") {(orig, terms) in
                    return orig + (terms.reduce("") {return $0 + ($0 == "" ? $1.description : " + \($1.description)")})
                }
            }
        }
        return str
    }
    
    public func variables() -> [String] {
        var prototype: [PolynomialTerm] = []
        let filtered = stack.filter {return $0.polynomial != nil}
        let reduced1 : [PolynomialTerm] = filtered.reduce(prototype) {return $0 + $1.polynomial!}
        let reduced2 = reduced1.reduce(NSSet()) {
            return $0.setByAddingObjectsFromSet(NSSet(array: Array($1.variables.keys)))
        }
        return (reduced2.allObjects as [String]).sorted {return $0 < $1}
    }
    
    public func degree() -> Double {
        return (stack.filter {
            return $0.polynomial != nil
        }.reduce([]) {
            return $0 + $1.polynomial!
        } as [PolynomialTerm]).reduce(0) {
            return max($0, $1.degree)
        }
    }
    
    public func valueAt(x: [String : Double]) -> Double? {
        while (stack.count > 1) {
            var polys : [Double] = []

            if let v = condenseTerms(stack.removeAtIndex(0).polynomial, x) {
                polys.append(v)
            } else {
                return nil;
            }
            var function : Function! = nil
            while true {
                let a = stack.removeAtIndex(0)
                if let v = condenseTerms(a.polynomial, x) {
                    polys.append(v)
                } else {
                    function = a.op!
                    break
                }
            }
            assert(function.numberOfInputs == polys.count, "")
            if let res = function.apply(polys) {
                stack.insert(([PolynomialTerm(scalar:res)], nil), atIndex: 0)
            } else {
                return nil
            }
            assert(stack.count != self.stack.count, "expected stack to be a mutable copy of self.stack, not to actually refer to it")
        }
        return condenseTerms(stack.first?.polynomial, x)
    }
    
    public func depth() -> Int {
        return stack.filter({ $0.polynomial != nil }).count - 1
    }
    
    public func performFunction(op: Function, on: [Polynomial]) -> Polynomial {
        assert(op.numberOfInputs == on.count + 1, "Expected op to work with inputs for function")
        var ret = self.copy() as Polynomial
        let stackPrimitive : [(polynomial: [PolynomialTerm]?, op: Function?)] = []
        let theStack : [(polynomial: [PolynomialTerm]?, op: Function?)] = on.reduce(stackPrimitive, combine: {return $0 + $1.stack}) + [(nil, op)]
        ret.stack += theStack
        return ret
    }
    
    private func combineTerms(terms: [PolynomialTerm]) -> [PolynomialTerm] {
        return terms.reduce([]) {(list: [PolynomialTerm], term: PolynomialTerm) in
            if term.coefficient != 0.0 {
                let inverted = term.invert()
                var lst = list
                for (i, x) in enumerate(lst) {
                    if x.variables == term.variables {
                        lst[i] = x + term
                        return lst
                    } else if x.variables == inverted.variables {
                        lst[i] = x - term
                        return lst
                    }
                }
                return lst + [term]
            }
            return list
        }
    }
    
    public func addPolynomial(p : Polynomial) -> Polynomial {
        if self.depth() == 0 && p.depth() == 0 {
            var sTerms = self.stack.first!.polynomial!
            var pTerms = p.stack.first!.polynomial!
            var c : [PolynomialTerm] = []
            
            var variables : [[String: Double]] = []
            
            for term1 in pTerms {
                let v1 = term1.variables
                var term2: PolynomialTerm? = nil
                for term in sTerms {
                    if (term.variables == v1) {
                        term2 = term
                    }
                }
                
                var v = term1
                if let t2 = term2 {
                    v = term1 + t2
                    variables.append(t2.variables)
                }
                c.append(v)
            }
            let otherTerms = filter(pTerms) {(term: PolynomialTerm) in
                return !cont(variables, term.variables)
            }
            for term in otherTerms {
                c.append(term)
            }
            
            return Polynomial(terms: self.combineTerms(c))
        }
        return self.performFunction(Addition(), on: [p])
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {
        if self.depth() == 0 && p.depth() == 0 {
            var sTerms = self.stack.first!.polynomial!
            var pTerms = p.stack.first!.polynomial!
            var c : [PolynomialTerm] = []
            
            var variables : [[String: Double]] = []
            
            for term1 in sTerms {
                let v1 = term1.variables
                var term2: PolynomialTerm? = nil
                for term in pTerms {
                    if (term.variables == v1) {
                        term2 = term
                    }
                }
                
                var v = term1
                if let t2 = term2 {
                    v = term1 - t2
                    variables.append(t2.variables)
                }
                c.append(v)
            }
            let otherTerms = filter(pTerms) {(term: PolynomialTerm) in
                return !cont(variables, term.variables)
            }
            for term in otherTerms {
                c.append((term * -1))
            }
            
            return Polynomial(terms: self.combineTerms(c))
        }
        return self.performFunction(Subtraction(), on: [p])
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {
        if self.depth() == 0 && p.depth() == 0 {
            var sTerms = self.stack.first!.polynomial!
            var pTerms = p.stack.first!.polynomial!
            var terms : [PolynomialTerm] = []
            
            for t1 in sTerms {
                for t2 in pTerms {
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
        }
        return self.performFunction(Multiplication(), on: [p])
    }
    
    public func dividePolynomial(p : Polynomial) -> Polynomial {
        return self.performFunction(Division(), on: [p])
    }
    
    public func exponentiatePolynomial(p : Polynomial) -> Polynomial {
        return self.performFunction(Exponentiation(), on: [p])
    }
    
    public func differentiate(respectTo: String) -> Polynomial? {
        var stack = self.stack
        var ret : [Polynomial] = []
        while (stack.count > 1) {
            var polys : [[PolynomialTerm]] = []
            if let p = stack.removeAtIndex(0).polynomial {
                polys.append(p)
            } else {
                return nil
            }
            var function : Function! = nil
            while true {
                let a = stack.removeAtIndex(0)
                if let p = a.polynomial {
                    polys.append(p)
                } else {
                    function = a.op!
                    break
                }
            }
            assert(function.numberOfInputs == polys.count, "")
            if let res = function.differentiate(polys, respectTo: respectTo) {
                ret.append(res)
            } else {
                return nil
            }
        }
        // FIXME: do stuff with ret to create a polynomial
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

public func == (a : Polynomial, b : Polynomial) -> Bool {
    return a.equals(b)
}

public func != (a : Polynomial, b : Polynomial) -> Bool {
    return !a.equals(b)
}

public func + (a : Polynomial, b : Polynomial) -> Polynomial {
    return a.addPolynomial(b);
}

public func += (inout a : Polynomial, b : Polynomial) {
    a = a + b
}

public func + (a : Polynomial, b : Double) -> Polynomial {
    return a.addPolynomial(Polynomial(scalar: b))
}

public func += (inout a : Polynomial, b : Double) {
    a = a + b
}

public func - (a : Polynomial, b : Polynomial) -> Polynomial {
    return a.subtractPolynomial(b)
}

public func -= (inout a : Polynomial, b : Polynomial) {
    a = a - b
}

public func - (a : Polynomial, b : Double) -> Polynomial {
    return a.subtractPolynomial(Polynomial(scalar: b))
}

public func -= (inout a : Polynomial, b : Double) {
    a = a - b
}

public func * (a : Polynomial, b : Polynomial) -> Polynomial {
    return a.multiplyPolynomial(b)
}

public func *= (inout a : Polynomial, b : Polynomial) {
    a = a * b
}

public func * (a : Polynomial, b : Double) -> Polynomial {
    return a.multiplyPolynomial(Polynomial(scalar: b))
}

public func *= (inout a : Polynomial, b : Double) {
    a = a * b
}

public func / (a : Polynomial, b : Polynomial) -> Polynomial {
    return a.dividePolynomial(b)
}

public func /= (inout a : Polynomial, b : Polynomial) {
    a = a / b
}

public func / (a : Polynomial, b : Double) -> Polynomial {
    return a.dividePolynomial(Polynomial(scalar: b))
}

public func /= (inout a : Polynomial, b : Double) {
    a = a / b
}
