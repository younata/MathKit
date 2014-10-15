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
    
    // want to represent f(x) = (x^2 + 1) / x
    // a stack or tree structure would work best...
    
    var tree : (left: Polynomial, op: Operations, right: Polynomial)? = nil
    
    public override init() {
        super.init()
    }
    
    public init(simplePolynomial: SimplePolynomial) {
        super.init(terms: simplePolynomial.terms)
    }
    
    public required init(scalar: Double) {
        super.init(scalar: scalar)
    }
    
    public init(polynomial : Polynomial) {
        super.init()
        tree = polynomial.tree
    }
    
    public init(tree: (left: Polynomial, op: Operations, right: Polynomial)) {
        super.init()
        self.tree = tree
    }
    
    
    public required init(string: String) {
        super.init(string: string) // meh, will do it later.
    }
    
    public required init(terms: [PolynomialTerm]) {
        super.init(terms: terms)
    }
    
    public override func copy() -> AnyObject {
        if let tree = self.tree {
            let l = tree.left.copy() as Polynomial
            let r = tree.right.copy() as Polynomial
            return Polynomial(tree: (left: l, op: tree.op, right: r))
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
        if let p = tree {
            str += "(\(p.left.toString)) \(p.op.toRaw()) (\(p.right.toString))"
        } else {
            return super.toString
        }
        return str
    }
    
    public override func variables() -> [String] {
        let set = NSMutableSet()
        if let p = tree {
            set.addObjectsFromArray(p.left.variables())
            set.addObjectsFromArray(p.right.variables())
        } else {
            return super.variables()
        }
        return set.allObjects as [String]
    }
    
    public override func degree() -> Double {
        var ret = 0.0
        if let p = tree {
            ret = max(ret, max(p.left.degree(), p.right.degree()))
        } else {
            return super.degree()
        }
        return ret
    }
    
    public override func valueAt(x: [String : Double]) -> Double {
        //TODO: Replace this with a Vector
        if let tree = self.tree {
            switch (tree.op) {
            case .Add:
                return tree.left.valueAt(x) + tree.right.valueAt(x)
            case .Subtract:
                return tree.left.valueAt(x) - tree.right.valueAt(x)
            case .Multiply:
                return tree.left.valueAt(x) * tree.right.valueAt(x)
            case .Divide:
                return tree.left.valueAt(x) / tree.right.valueAt(x)
            case .Exponentiate:
                return pow(tree.left.valueAt(x), tree.right.valueAt(x))
            }
        } else {
            return super.valueAt(x)
        }
    }
    
    public var hasTree : Bool {
        return tree != nil
    }
    
    public func depth() -> Int {
        var r = 0
        if let t = tree {
            r += max(t.right.depth(), t.left.depth())
        }
        return r
    }
    
    private func performOp(op: Operations, on: Polynomial) -> Polynomial {
        let ret = self.copy() as Polynomial
        var ops : [String] = []
        if let tree = ret.tree {
            var rightMost = tree.right
            ops.append(tree.op.toRaw())
            while rightMost.tree != nil {
                ops.append(rightMost.tree!.op.toRaw())
                rightMost = rightMost.tree!.right
            }
            rightMost.tree = (left: Polynomial(simplePolynomial: rightMost), op: op, right: on)
            rightMost.terms = []
        } else {
            var rightMost = self
            ret.tree = (left: self, op: op, right: on)
        }
        
        // TODO: See if "balancing" the tree would increase performance.
        // It won't. The only times we ever traverse the tree are to get information about ALL of the polynomials in it.
        // Might as well just replace the entire structure with a list
        
        return ret
    }
    
    public func addPolynomial(p : Polynomial) -> Polynomial {
        if p.tree == nil && self.tree == nil && super.canAdd(p) {
            return Polynomial(simplePolynomial: super.add(SimplePolynomial(terms: p.terms)))
        }
        
        return self.performOp(.Add, on: p)
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {
        if p.tree == nil && self.tree == nil && super.canSubtract(p) {
            return Polynomial(simplePolynomial: super.subtract(SimplePolynomial(terms: p.terms)))
        }
        
        return self.performOp(.Subtract, on: p)
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {
        if p.tree == nil && self.tree == nil && super.canMultiply(p) {
            return Polynomial(simplePolynomial: super.multiply(SimplePolynomial(terms: p.terms)))
        }
        
        return self.performOp(.Multiply, on: p)
    }
    
    public func dividePolynomial(p : Polynomial) -> Polynomial {
        return self.performOp(.Divide, on: p)
    }
    
    public func exponentiateBy(p : Polynomial) -> Polynomial {
        return self.performOp(.Exponentiate, on: p)
    }
    
    public override func differentiate(respectTo: String) -> Polynomial {
        // and this is where things get annoying.
        var ret = Polynomial()
        if let t = tree {
            switch (t.op) {
            case .Add, .Subtract:
                if t.op == .Add {
                    ret = t.left.differentiate(respectTo) + t.right.differentiate(respectTo)
                } else {
                    ret = t.left.differentiate(respectTo) - t.right.differentiate(respectTo)
                }
                break
            case .Multiply, .Divide:
                // oh. gods...
                break
            case .Exponentiate:
                // fuck.
                break
            }
        } else {
            return Polynomial(simplePolynomial: super.differentiate(respectTo))
        }
        return 0
    }
    
    public override func gradient() -> Vector {
        return Vector(polynomials: ["x": 0])
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
