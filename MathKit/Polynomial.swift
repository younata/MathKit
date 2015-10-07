import Foundation

public struct Polynomial : Equatable, CustomStringConvertible { // TODO: add Comparable
    
    var stack : [(polynomial: [PolynomialTerm]?, op: Function?)] = []

    public init() {}

    public init(terms: [PolynomialTerm]) {
        self.init(stack: [(terms, nil)])
    }

    public init(polynomial : Polynomial) {
        self.stack = polynomial.stack
    }
    
    public init(var stack: [(polynomial: [PolynomialTerm]?, op: Function?)]) {
        for (i, po) in stack.enumerate() {
            if let p = po.polynomial {
                let x = reduceTerms(p)
                stack[i] = (polynomial: (x.count != 0 ? x : nil), op: nil)
            }
        }
        let filteredStack = stack.filter {return $0.polynomial != nil || $0.op != nil}

        var stack = filteredStack
        for itm in filteredStack {
            if let op = itm.op {
                if ["+", "-", "*"].contains(op.description) {
                    var p1 = Polynomial(terms: stack[0].polynomial!)
                    let p2 = Polynomial(terms: stack[1].polynomial!)
                    switch (op.description) {
                    case "+":
                        p1 = p1.addPolynomial(p2)
                    case "-":
                        p1 = p1.subtractPolynomial(p2)
                    case "*":
                        p1 = p1.multiplyPolynomial(p2)
                    default:
                        assert(false, "")
                    }
                    if p1.stack.count == 1 {
                        stack.removeAtIndex(0) // Removes what became p1
                        stack.removeAtIndex(0) // Removes what became p2
                        stack.removeAtIndex(0) // Removes the op
                        stack.insert(p1.stack[0], atIndex: 0)
                    } else {
                        break
                    }
                } else {
                    break
                }
            }
        }
        self.stack = stack
    }
    
    public init(scalar: Double) {
        self.init(terms: [PolynomialTerm(scalar: scalar)])
    }
    
    // eg: (3x^2 + x + 1)
    // (2x^2 + x + 1) (x) /
    public init(string: String) {
        let scanner = NSScanner(string: string)

        let openParen = "("
        let closeParen = ")"

        // there has got to be a better way to do this...

        let functions : [String: Function] = ["+": Addition(), "-": Subtraction(),
            "*": Multiplication(), "/": Division(), "**": Exponentiation()]

        let characterSet = NSCharacterSet(charactersInString: "+-*/")

        var inPolynomial = true
        var searchForCloseParen = scanner.scanUpToString(openParen, intoString: nil)

        var stack: [(polynomial: [PolynomialTerm]?, op: Function?)] = []

        let loc = 0

        while !scanner.atEnd {
            if inPolynomial {

                if scanner.scanUpToString(closeParen, intoString: nil) {
                    scanner.scanLocation = loc
                }

                if searchForCloseParen && scanner.scanUpToString(closeParen, intoString: nil) {
                    inPolynomial = false
                    searchForCloseParen = false
                }
            } else {
                if scanner.scanUpToCharactersFromSet(characterSet, intoString: nil) {
                    let str = (scanner.string as NSString).substringFromIndex(scanner.scanLocation)
                    var function : Function? = nil
                    if str.hasPrefix("**") {
                        function = Exponentiation()
                    } else if str.hasPrefix("*") {
                        function = Multiplication()
                    } else if str.hasPrefix("/") {
                        function = Division()
                    } else if str.hasPrefix("-") {
                        function = Subtraction()
                    } else if str.hasPrefix("+") {
                        function = Addition()
                    } else {
                        // ERROR!
                    }
                    let toAdd: (polynomial: [PolynomialTerm]?, op: Function?) = (polynomial: nil, op: function)
                    stack.append(toAdd)
                } else {
                    break
                }

                if scanner.scanUpToString(openParen, intoString: nil) {
                    inPolynomial = true
                    searchForCloseParen = true
                }
                let loc = scanner.scanLocation
                if scanner.scanPolynomialTerm() != nil {
                    scanner.scanLocation = loc
                    inPolynomial = true
                }
            }
        }

        self.init(stack: stack)
    }

    public static func interpolate(input: [[Double]], output: [Double]) -> Polynomial? {
        return nil; // FIXME: implement interpolation
    }

    public var description : String {
        var varsUsed = self.variables()
        var v = ""
        varsUsed.sortInPlace { $0 < $1 }
        for s in varsUsed {
            if (!v.isEmpty) {
                v += ", "
            }
            v += s
        }
        return "f(\(v)) = \(self.toString)"
    }
    
    public func equals(p: Polynomial) -> Bool {
        return self.description == p.description // FIXME: This is a terrible way to do comparisons.
    }
    
    private func termsString(terms: [PolynomialTerm]) -> String {
        var str = ""
        let t = terms.sort({ $0 < $1 })
        
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
        var stack = self.stack
        while (stack.count > 0) {
            var polys : [[PolynomialTerm]] = []
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
                if function.isOperator && function.numberOfInputs == 2 {
                    if polys.count == 2 {
                        str += "(\(termsString(polys[c-1]))) \(function.description) (\(termsString(polys[c])))"
                    } else {
                        str += "(\(function.description)"
                        if let l = polys.last {
                            str += "(\(termsString(l)))"
                        }
                    }
                } else {
                    str = function.description + "(" + str
                    str += "\(function.description)("
                    for (i, p) in polys.enumerate() {
                        str += "\(termsString(p))"
                        if i != (polys.count - 1) {
                            str += ", "
                        }
                    }
                    str += ") "
                }
                for (var i = 0; i < (polys.count - function.numberOfInputs); i++) {
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
        let filtered = stack.filter {return $0.polynomial != nil}
        let reduced1 : [PolynomialTerm] = filtered.reduce(Array<PolynomialTerm>()) {return $0 + $1.polynomial!}
        let reduced2 = reduced1.reduce(Set<String>()) {
            return $0.union(Set(Array($1.variables.keys)))
        }
        return Array(reduced2).sort {return $0 < $1}
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

            var theFunction : Function? = nil
            var stack = self.stack
            while true {
                if stack.count == 0 {
                    break;
                }
                let a = stack.removeAtIndex(0)
                if let v = condenseTerms(a.polynomial, at: x) {
                    polys.append(v)
                } else {
                    theFunction = a.op
                    break
                }
            }
            if let function = theFunction {
                assert(function.numberOfInputs <= polys.count, "")
                let c = polys.count - function.numberOfInputs
                var p : [Double] = []
                for (i, x) in polys.enumerate() {
                    if i < c {
                        p.append(x)
                    } else {
                        break
                    }
                }
                if let res = function.apply(p) {
                    stack.insert(([PolynomialTerm(scalar:res)], nil), atIndex: 0)
                } else {
                    return nil
                }
            } else {
                return nil
            }
            assert(stack.count != self.stack.count, "expected stack to be a mutable copy of self.stack, not to actually refer to it")
        }
        return condenseTerms(stack.first?.polynomial, at: x)
    }
    
    public func polynomialAt(at: [String: Double]) -> Polynomial {
        return Polynomial() // TODO: Implement polynomial at certain variables.
    }
    
    public func polynomialComposition(at: [String: Polynomial]) -> Polynomial {
        // Creating f(g(x)) from f(x) and g(x).
        // Should also do f(g(x), y) or whatever.
        return Polynomial() // TODO: Implement polynomial at certain polynomials.
    }
    
    public func depth() -> Int {
        return stack.filter({ $0.polynomial != nil }).count - 1
    }
    
    public func performFunction(op: Function, on: [Polynomial]) -> Polynomial {
        assert(op.numberOfInputs == on.count + 1, "Expected op to work with inputs for function")
        var ret = self
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
                for (i, x) in lst.enumerate() {
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
        if self.depth() == 0 && p.depth() == 0 && self.stack.first?.polynomial != nil && p.stack.first?.polynomial != nil {
            let sTerms = self.stack.first!.polynomial!
            let pTerms = p.stack.first!.polynomial!
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
            let otherTerms = pTerms.filter {(term: PolynomialTerm) in
                return !cont(variables, obj: term.variables)
            }
            for term in otherTerms {
                c.append(term)
            }
            
            return Polynomial(terms: self.combineTerms(c))
        }
        return self.performFunction(Addition(), on: [p])
    }
    
    public func subtractPolynomial(p: Polynomial) -> Polynomial {
        if self.depth() == 0 && p.depth() == 0 && self.stack.first?.polynomial != nil && p.stack.first?.polynomial != nil {
            let sTerms = self.stack.first!.polynomial!
            let pTerms = p.stack.first!.polynomial!
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
            let otherTerms = pTerms.filter {(term: PolynomialTerm) in
                return !cont(variables, obj: term.variables)
            }
            for term in otherTerms {
                c.append((term * -1))
            }
            
            return Polynomial(terms: self.combineTerms(c))
        }
        return self.performFunction(Subtraction(), on: [p])
    }

    public func multiplyPolynomial(p: Polynomial) -> Polynomial {
        if self.depth() == 0 && p.depth() == 0 && self.stack.first?.polynomial != nil && p.stack.first?.polynomial != nil {
            let sTerms = self.stack.first!.polynomial!
            let pTerms = p.stack.first!.polynomial!
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
        while (stack.count > 0) {
            var polys : [[PolynomialTerm]] = []
            var theFunction : Function? = nil
            while true {
                if stack.count == 0 {
                    break
                }
                let a = stack.removeAtIndex(0)
                if let p = a.polynomial {
                    polys.append(p)
                } else if let o = a.op {
                    theFunction = o
                    break
                } else {
                    return nil
                }
            }
            if let function = theFunction {
                assert(function.numberOfInputs == polys.count, "")
                if let res = function.differentiate(polys, respectTo: respectTo) {
                    ret.append(res)
                } else {
                    return nil
                }
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

public func ** (a : Polynomial, b : Double) -> Polynomial {
    return a.exponentiatePolynomial(Polynomial(scalar: b))
}

public func **= (inout a : Polynomial, b : Double) {
    a = a ** b
}

public func ** (a : Polynomial, b : Polynomial) -> Polynomial {
    return a.exponentiatePolynomial(b)
}

public func **= (inout a : Polynomial, b : Polynomial) {
    a = a ** b
}
