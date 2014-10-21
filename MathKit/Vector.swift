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
            for t in variables.keys {
                ret += "\(t): \(variables[t])\n"
            }
            return ret
    }
    
    public var dimensions : Int {
        return self.variables.count
    }
    
    public func scalarAddition(s : Double) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]! + s
        }
        return Vector(polynomials: iables)
    }
    
    public func scalarSubtraction(s : Double) -> Vector {
        return scalarAddition(-s)
    }
    
    public func scalarMultiplication(s : Double) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]! * s
        }
        return Vector(polynomials: iables)
    }
    
    public func scalarDivision(s : Double) -> Vector {
        return scalarMultiplication(1.0 / s)
    }
    
    public func addScalar(s: Double, to variable: String) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        if let c = iables[variable] {
            iables[variable] = c + s
        } else {
            iables[variable] = SimplePolynomial(scalar: s)
        }
        return Vector(polynomials: iables)
    }
    
    public func subtractScalar(s: Double, from variable: String) -> Vector {
        return addScalar(-s, to: variable)
    }
    
    public func multiplyScalar(s: Double, on variable: String) -> Vector {
        var iables : [String : SimplePolynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        if let c = iables[variable] {
            iables[variable] = c * s
        } // 0 * anything is zero...
        return Vector(polynomials: iables)
    }
    
    public func divideScalar(s: Double, on variable: String) -> Vector {
        return multiplyScalar(1.0 / s, on: variable)
    }
    
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

public func gradient(field: [Vector], dimensions: Vector) -> [Vector] {
    return []
}

public func divergence(field: [Vector], dimensions: Vector) -> [Vector] {
    return []
}

public func curl(field: [Vector], dimensions: Vector) -> [Vector] {
    if dimensions.variables.count != 3 {
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

public func + (a : Vector, b : Double) -> Vector {
    return a.scalarAddition(b)
}

public func += (inout a : Vector, b : Double) {
    a = a + b
}

public func - (a : Vector, b : Vector) -> Vector {
    return a.vectorSubtraction(b)
}

public func -= (inout a : Vector, b : Vector) {
    a = a - b
}

public func - (a : Vector, b : Double) -> Vector {
    return a.scalarSubtraction(b)
}

public func -= (inout a : Vector, b : Double) {
    a = a - b
}

public func * (a : Vector, b : Vector) -> Vector {
    return a.vectorMultiplication(b)
}

public func *= (inout a : Vector, b : Vector) {
    a = a * b
}

public func * (a : Vector, b : Double) -> Vector {
    return a.scalarMultiplication(b)
}

public func *= (inout a : Vector, b : Double) {
    a = a * b
}

/*
public func / (a : Vector, b : Vector) -> Vector {
    return a.vectorDivision(b)
}

public func /= (inout a : Vector, b : Vector) {
    a = a / b
}*/

public func / (a : Vector, b : Double) -> Vector {
    return a.scalarDivision(b)
}

public func /= (inout a : Vector, b : Double) {
    a = a / b
}
