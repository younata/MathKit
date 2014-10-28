//
//  Polynomial.swift
//  CFDKit
//
//  Created by Rachel Brindle on 8/14/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class Polynomial : SimplePolynomial {
    
    public enum Operations : String {
        case Add = "+"
        case Subtract = "-"
        case Multiply = "*"
        case Divide = "/"
        case Exponentiate = "**"
        
        func associates(op: Operations) -> Bool {
            if (self != op) {
                return false
            }
            
            return self == .Add || self == .Multiply
        }
    }
    
    var stack : [(polynomial: SimplePolynomial?, op: Operations?)]? = nil
        
    public override init() {
        super.init()
    }
    
    public init(simplePolynomial: SimplePolynomial) {
        super.init(terms: simplePolynomial.terms)
    }
    
    /*
    public convenience init(scalar: Double) {
        super.init(scalar: scalar)
    }*/
    
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
        if var s = stack {
            let a = s.removeAtIndex(0).polynomial!
            str += "(\(a.toString))"
            
            while s.count > 0 {
                let b = s.removeAtIndex(0).polynomial!
                let op = s.removeAtIndex(0).op!
                
                str += "\(op.rawValue) + (\(b.toString))"
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
    
    public override func valueAt(x: [String : Double]) -> Double {
        if var stack = self.stack {
            while (stack.count > 1) {
                var a = stack.removeAtIndex(0).polynomial!
                var b = stack.removeAtIndex(0).polynomial!
                assert(stack.count != 0, "stack underflow")
                let c = stack.removeAtIndex(0).op!
                var res : SimplePolynomial? = nil
                switch (c) {
                case .Add:
                    res = SimplePolynomial(scalar: a.valueAt(x) + b.valueAt(x))
                case .Subtract:
                    res = SimplePolynomial(scalar: a.valueAt(x) + b.valueAt(x))
                case .Multiply:
                    res = SimplePolynomial(scalar: a.valueAt(x) + b.valueAt(x))
                case .Divide:
                    res = SimplePolynomial(scalar: a.valueAt(x) + b.valueAt(x))
                case .Exponentiate:
                    res = SimplePolynomial(scalar: pow(a.valueAt(x), b.valueAt(x)))
                }
                if let r = res {
                    stack.insert((res, nil), atIndex: 0)
                } else {
                    fatalError("res should not be nil")
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
            return ((s.count - 1) / 2) + 1
        }
        return 0
    }
    
    private func performOp(op: Operations, on: Polynomial) -> Polynomial {
        var ret = self.copy() as Polynomial
        var stackToAdd : [(polynomial: SimplePolynomial?, op: Operations?)] = []
        stackToAdd = [(on, nil), (nil, op)]
        if let os = on.stack {
            let a = os.first?.polynomial!
            let rest = os.filter { return $0.polynomial! != a }
            stackToAdd = [(a, nil), (nil, op)] + rest
        }
        if ret.stack != nil {
            ret.stack! += stackToAdd
        } else {
            ret = Polynomial(stack: [((self.copy() as Polynomial), nil)] + stackToAdd)
        }
        
        return ret
    }
    
    public func addPolynomial(p : Polynomial) -> Polynomial {
        /*
        if p.stack == nil && self.stack == nil && super.canAdd(p) {
            let ret = super.add(p)
            return Polynomial(simplePolynomial: ret)
        }*/
        return self.performOp(.Add, on: p)
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {/*
        if p.stack == nil && self.stack == nil && super.canSubtract(p) {
            return Polynomial(simplePolynomial: super.subtract(SimplePolynomial(terms: p.terms)))
        }*/
        
        return self.performOp(.Subtract, on: p)
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {/*
        if p.stack == nil && self.stack == nil && super.canMultiply(p) {
            return Polynomial(simplePolynomial: super.multiply(SimplePolynomial(terms: p.terms)))
        }*/
        
        return self.performOp(.Multiply, on: p)
    }
    
    public func dividePolynomial(p : Polynomial) -> Polynomial {
        return self.performOp(.Divide, on: p)
    }
    
    public func exponentiatePolynomial(p : Polynomial) -> Polynomial {
        return self.performOp(.Exponentiate, on: p)
    }
    
    public override func differentiate(respectTo: String) -> Polynomial {
        if var stack = self.stack {
            while (stack.count > 2) {
                let a = stack.removeAtIndex(0).polynomial!
                let b = stack.removeAtIndex(0).polynomial!
                let op = stack.removeAtIndex(0).op!
                var ret: Polynomial? = nil
                switch (op) {
                case .Add, .Subtract:
                    if (op == .Add) {
                        ret = Polynomial(simplePolynomial: a.differentiate(respectTo) + b.differentiate(respectTo))
                    } else {
                        ret = Polynomial(simplePolynomial: a.differentiate(respectTo) - b.differentiate(respectTo))
                    }
                    stack.insert((ret!, nil), atIndex: 0)
                    break
                case .Multiply, .Divide:
                    // I have no idea how to do this
                    break
                case .Exponentiate:
                    // I have no idea how to do this
                    break
                }
            }
            assert(stack.count == 1, "")
        } else {
            return Polynomial(simplePolynomial: super.differentiate(respectTo))
        }
        return Polynomial()
    }
    
    public override func gradient() -> Vector {
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
