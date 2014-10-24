//
//  Vector.swift
//  CFDKit
//
//  Created by Rachel Brindle on 8/12/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public class Vector: NSObject, Equatable, Printable {
    public var variables : [String: SimplePolynomial] = [:]
    
    public init(scalars: [String: Double]) {
        for key in scalars.keys {
            if let s = scalars[key] {
                self.variables[key] = SimplePolynomial(scalar: s)
            }
        }
    }
    
    public init(polynomials: [String: SimplePolynomial]) {
        self.variables = polynomials
    }
    
    public override func isEqual(object: AnyObject!) -> Bool {
        if !object.isKindOfClass(Vector.classForCoder()) {
            return false
        }
        return (object as Vector).variables == self.variables
    }
    
    public override var description : String {
        var ret = ""
        var keys : [String] = []
        for key in variables.keys {
            keys.append(key)
        }
        keys.sort { return $0 < $1 }
        for t in keys {
            ret += "\(t): \(variables[t]!)\n"
        }
        return ret
    }
    
    public var dimensions : Int {
        return self.variables.count
    }
    
    public func scalarAddition(s : SimplePolynomial) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]! + s
        }
        return Vector(polynomials: iables)
    }
    
    public func scalarSubtraction(s : SimplePolynomial) -> Vector {
        let p = s * -1
        return scalarAddition(p)
    }
    
    public func scalarMultiplication(s : SimplePolynomial) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]! * s
        }
        return Vector(polynomials: iables)
    }
    
    /*
    public func scalarDivision(s : Double) -> Vector {
        return scalarMultiplication(1.0 / s)
    }*/
    
    public func addScalar(s: SimplePolynomial, to variable: String) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        if let c = iables[variable] {
            iables[variable] = c + s
        } else {
            iables[variable] = s
        }
        return Vector(polynomials: iables)
    }
    
    public func subtractScalar(s: SimplePolynomial, from variable: String) -> Vector {
        let p = s * -1
        return addScalar(p, to: variable)
    }
    
    public func multiplyScalar(s: SimplePolynomial, on variable: String) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        if let c = iables[variable] {
            iables[variable] = c * s
        } // 0 * anything is zero...
        return Vector(polynomials: iables)
    }
    
    /*
    public func divideScalar(s: Double, on variable: String) -> Vector {
        return multiplyScalar(1.0 / s, on: variable)
    }*/
    
    public func vectorAddition(vector : Vector) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        for key in vector.variables.keys {
            let p = vector.variables[key]!
            if let c = iables[key] {
                iables[key] = c + p
            } else {
                iables[key] = p
            }
        }
        
        return Vector(polynomials: iables)
    }
    
    public func vectorSubtraction(vector: Vector) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        for key in vector.variables.keys {
            let p = vector.variables[key]!
            if let c = iables[key] {
                iables[key] = c - p
            } else {
                iables[key] = p
            }
        }
        
        return Vector(polynomials: iables)
    }
    
    public func vectorMultiplication(vector: Vector) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        for key in vector.variables.keys {
            let p = vector.variables[key]!
            if let c = iables[key] {
                iables[key] = iables[key]! * p
            } else {
                iables[key] = p
            }
        }
        
        return Vector(polynomials: iables)
    }
    /*
    public func vectorDivision(vector: Vector) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        for key in vector.variables.keys {
            let p = vector.variables[key]!
            if let c = iables[key] {
                let cp = c / p
                iables[key] = cp
            } else {
                iables[key] = p
            }
        }
        
        return Vector(polynomials: iables)
    }*/
    
    public func dotProduct(vector: Vector) -> SimplePolynomial {
        var ret = SimplePolynomial()
        for key in variables.keys {
            if vector.variables[key] != nil {
                ret = ret + variables[key]! + vector.variables[key]!
            }
        }
        return ret
    }
}

public func gradient(field: [Vector], dimensions: [String: Int], order: [String]) -> [Vector] {
    return []
}

public func divergence(field: [Vector], dimensions: [String: Int], order: [String]) -> [Vector] {
    return []
}

public func curl(field: [Vector], dimensions: [String: Int], order: [String]) -> [Vector] {
    if order.count != 3 {
        return []
    }
    return []
}

public func == (a : Vector, b : Vector) -> Bool {
    return a.isEqual(b)
}

public func + (a : Vector, b : Vector) -> Vector {
    return a.vectorAddition(b);
}

public func += (inout a : Vector, b : Vector) {
    a = a + b
}

public func + (a : Vector, b : SimplePolynomial) -> Vector {
    return a.scalarAddition(b)
}

public func += (inout a : Vector, b : SimplePolynomial) {
    a = a + b
}

public func - (a : Vector, b : Vector) -> Vector {
    return a.vectorSubtraction(b)
}

public func -= (inout a : Vector, b : Vector) {
    a = a - b
}

public func - (a : Vector, b : SimplePolynomial) -> Vector {
    return a.scalarSubtraction(b)
}

public func -= (inout a : Vector, b : SimplePolynomial) {
    a = a - b
}

public func * (a : Vector, b : Vector) -> Vector {
    return a.vectorMultiplication(b)
}

public func *= (inout a : Vector, b : Vector) {
    a = a * b
}

public func * (a : Vector, b : SimplePolynomial) -> Vector {
    return a.scalarMultiplication(b)
}

public func *= (inout a : Vector, b : SimplePolynomial) {
    a = a * b
}

/*
public func / (a : Vector, b : Vector) -> Vector {
    return a.vectorDivision(b)
}

public func /= (inout a : Vector, b : Vector) {
    a = a / b
}

public func / (a : Vector, b : SimplePolynomial) -> Vector {
    return a.scalarDivision(b)
}

public func /= (inout a : Vector, b : SimplePolynomial) {
    a = a / b
}*/
