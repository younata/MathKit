//
//  Polynomial.swift
//  CFDKit
//
//  Created by Rachel Brindle on 8/14/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class Polynomial : SimplePolynomial {
    
    var stack : [(polynomial: SimplePolynomial?, op: Function?)]? = nil
        
    public override init() {
        super.init()
    }
    
    public init(simplePolynomial: SimplePolynomial) {
        super.init(terms: simplePolynomial.terms)
    }

    public init(polynomial : Polynomial) {
        super.init()
        stack = polynomial.stack
    }
    
    public init(stack: [(polynomial: SimplePolynomial?, op: Operations?)]) {
        super.init()
        self.stack = stack
    }
    
    /*
    public convenience init(string: String) {
        super.init(string: string) // meh, will do it later.
    }*/
    
    public required init(terms: [PolynomialTerm]) {
        super.init(terms: terms)
    }
    
    public override func copy() -> AnyObject {
        if self.stack != nil {
            let s = self.stack!
            return Polynomial(stack: s)
        } else {
            return Polynomial(simplePolynomial: self)
        }
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
    
    public override var toString : String {
        var str = ""
        if var stack = self.stack {
            while (stack.count > 0) {
                var polys : [Polynomial] = []
                polys.append(stack.removeAtIndex(0).polynomial!)
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
                if function.isOperator && function.numberOfInputs == 2 {
                    if polys.count == 2 {
                        str += "(\(polys.first!.toString)) \(function.description) (\(polys.last!.toString))"
                    } else {
                        str += "(\(function.description) (\(polys.last!.toString))"
                    }
                } else {
                    str = function.description + "(" + str
                    str += "\(function.description)("
                    for (i, p) in enumerate(polys) {
                        str += "\(polys.toString)"
                        if i != (polys.count - 1) {
                            str += ", "
                        }
                    }
                    str += ") "
                }
            }
        } else {
            return super.toString
        }
        return str
    }
    
    public override func variables() -> [String] {
        if let s = stack {
            var prototype: [SimplePolynomial] = []
            let filtered = s.filter {return $0.polynomial != nil}
            let reduced1 : [SimplePolynomial] = filtered.reduce(prototype) {return $0 + [$1.polynomial!]}
            let reduced2 = reduced1.reduce(NSSet()) {
                let set = NSSet(array: $1.variables())
                return $0.setByAddingObjectsFromSet(set)
            }
            return (reduced2.allObjects as [String])
        } else {
            return super.variables()
        }
    }
    
    public override func degree() -> Double {
        if let s = stack {
            return (s.filter {
                return $0.polynomial != nil
            }.reduce([]) {
                return $0 + [$1.polynomial!]
            } as [SimplePolynomial]).reduce(0) {
                return max($0, $1.degree())
            }
        } else {
            return super.degree()
        }
    }
    
    public override func valueAt(x: [String : Double]) -> Double? {
        if var stack = self.stack {
            while (stack.count > 1) {
                var polys : [Polynomial] = []
                polys.append(stack.removeAtIndex(0).polynomial!)
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
                if let res = function.apply(polys) {
                    stack.insert((SimplePolynomial(scalar:res), nil), atIndex: 0)
                } else {
                    return nil
                }
                assert(stack.count != self.stack!.count, "expected stack to be a mutable copy of self.stack, not to actually refer to it")
            }
            return stack.first!.polynomial!.valueAt(x)
        } else {
            return super.valueAt(x)
        }
    }
    
    public var hasStack : Bool {
        return stack != nil
    }
    
    public func depth() -> Int {
        if let s = stack {
            return s.filter({ $0.polynomial != nil }).count - 1
        }
        return 0
    }
    
    private func performFunction(op: Function, on: [Polynomial]) -> Polynomial {
        assert(op.numberOfInputs == on.count + 1, "Expected op to work with inputs for function")
        var ret = self.copy() as Polynomial
        let stackToAdd = on.map {return ($0, nil)} + (nil, op)
        if ret.stack != nil {
            ret.stack! += stackToAdd
        } else {
            ret = Polynomial(stack: [(ret, nil)] + stackToAdd)
        }
        
        return ret
    }
    
    public func addPolynomial(p : Polynomial) -> Polynomial {
        if p.stack == nil && self.stack == nil && self.canAdd(p) {
            let ret = self.add(p)
            return Polynomial(simplePolynomial: ret)
        }
        return self.performFunction(Addition(), on: [p])
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {
        if p.stack == nil && self.stack == nil && self.canSubtract(p) {
            return Polynomial(simplePolynomial: self.subtract(p))
        }
        
        return self.performOp(Subtraction(), on: [p])
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {
        if p.stack == nil && self.stack == nil && self.canMultiply(p) {
            return Polynomial(simplePolynomial: self.multiply(p))
        }
        
        return self.performOp(Multiplication(), on: [p])
    }
    
    public func dividePolynomial(p : Polynomial) -> Polynomial {
        return self.performOp(Division(), on: [p])
    }
    
    public func exponentiatePolynomial(p : Polynomial) -> Polynomial {
        return self.performOp(Exponentiation(), on: [p])
    }
    
    public override func differentiate(respectTo: String) -> Polynomial? {
        if var stack = self.stack {
            while (stack.count > 1) {
                var polys : [Polynomial] = []
                polys.append(stack.removeAtIndex(0).polynomial!)
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
                let ret = function.differentiate(polys, respectTo: respectTo)
                stack.insert((ret!, nil), atIndex: 0)
            }
            assert(stack.count == 1, "")
        } else {
            return Polynomial(simplePolynomial: super.differentiate(respectTo))
        }
        return Polynomial()
    }
    
    public override func gradient() -> Vector? {
        return Vector(polynomials: self.variables().reduce([:]) {(dict: [String: SimplePolynomial], variable: String) in
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
