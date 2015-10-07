import Foundation

public struct Vector: Equatable, CustomStringConvertible {
    public var variables : [String: Polynomial] = [:]
    
    public init(scalars: [String: Double]) {
        for key in scalars.keys {
            if let s = scalars[key] {
                self.variables[key] = Polynomial(scalar: s)
            }
        }
    }
    
    public init(polynomials: [String: Polynomial]) {
        self.variables = polynomials
    }
    
    public func isEqual(object: Vector) -> Bool {
        return object.variables == self.variables
    }
    
    public var description : String {
        var ret = ""
        var keys : [String] = []
        for key in variables.keys {
            keys.append(key)
        }
        keys.sortInPlace { return $0 < $1 }
        for t in keys {
            ret += "\(t): \(variables[t]!)\n"
        }
        return ret
    }
    
    public var dimensions : Int {
        return self.variables.count
    }
    
    public func scalarAddition(s : Polynomial) -> Vector {
        var iables : [String : Polynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]! + s
        }
        return Vector(polynomials: iables)
    }
    
    public func scalarSubtraction(s : Polynomial) -> Vector {
        let p = s * -1
        return scalarAddition(p)
    }
    
    public func scalarMultiplication(s : Polynomial) -> Vector {
        var iables : [String : Polynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]! * s
        }
        return Vector(polynomials: iables)
    }
    
    /*
    public func scalarDivision(s : Double) -> Vector {
        return scalarMultiplication(1.0 / s)
    }*/
    
    public func addScalar(s: Polynomial, to variable: String) -> Vector {
        var iables : [String : Polynomial] = [:]
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
    
    public func subtractScalar(s: Polynomial, from variable: String) -> Vector {
        let p = s * -1
        return addScalar(p, to: variable)
    }
    
    public func multiplyScalar(s: Polynomial, on variable: String) -> Vector {
        var iables : [String : Polynomial] = [:]
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
        var iables : [String : Polynomial] = [:]
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
        var iables : [String : Polynomial] = [:]
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
        var iables : [String : Polynomial] = [:]
        for key in variables.keys {
            iables[key] = variables[key]!
        }
        for key in vector.variables.keys {
            let p = vector.variables[key]!
            if let c = iables[key] {
                iables[key] = c * p
            } else {
                iables[key] = p
            }
        }
        
        return Vector(polynomials: iables)
    }
    /*
    public func vectorDivision(vector: Vector) -> Vector {
        var iables : [String : Polynomial] = [:]
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
    
    public func dotProduct(vector: Vector) -> Polynomial {
        var ret = Polynomial()
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

public func + (a : Vector, b : Polynomial) -> Vector {
    return a.scalarAddition(b)
}

public func += (inout a : Vector, b : Polynomial) {
    a = a + b
}

public func - (a : Vector, b : Vector) -> Vector {
    return a.vectorSubtraction(b)
}

public func -= (inout a : Vector, b : Vector) {
    a = a - b
}

public func - (a : Vector, b : Polynomial) -> Vector {
    return a.scalarSubtraction(b)
}

public func -= (inout a : Vector, b : Polynomial) {
    a = a - b
}

public func * (a : Vector, b : Vector) -> Vector {
    return a.vectorMultiplication(b)
}

public func *= (inout a : Vector, b : Vector) {
    a = a * b
}

public func * (a : Vector, b : Polynomial) -> Vector {
    return a.scalarMultiplication(b)
}

public func *= (inout a : Vector, b : Polynomial) {
    a = a * b
}

/*
public func / (a : Vector, b : Vector) -> Vector {
    return a.vectorDivision(b)
}

public func /= (inout a : Vector, b : Vector) {
    a = a / b
}

public func / (a : Vector, b : Polynomial) -> Vector {
    return a.scalarDivision(b)
}

public func /= (inout a : Vector, b : Polynomial) {
    a = a / b
}*/
