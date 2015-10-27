import Foundation

extension String {
    private subscript(value: Int) -> String {
        var start = self.startIndex
        for _ in 0..<value {
            start = start.successor()
            if start == self.endIndex {
                return ""
            }
        }
        return self.substringWithRange(Range(start: start, end: start.successor()))
    }
}

extension NSScanner {
    internal func scanPolynomialTerm() -> PolynomialTerm? {
        let string = (self.string as NSString).substringFromIndex(self.scanLocation)

        if (string.isEmpty) {
            return nil
        }

        let scanner = NSScanner(string: string)
        let set = NSMutableCharacterSet.letterCharacterSet()

        var coefficient = 0.0
        let isNegative: Bool
        if !scanner.scanDouble(&coefficient) && string.hasPrefix("-") {
            isNegative = true
            scanner.scanLocation = 1
        } else {
            isNegative = false
        }
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
            coefficient = 1.0 * (isNegative ? -1.0 : 1.0)
        }

        if coefficient == 0.0 {
            return nil
        }
        self.scanLocation += scanner.scanLocation
        return PolynomialTerm(coefficient: coefficient, variables: variables)
    }

    public func scanPolynomial() -> Polynomial? {
        let string = (self.string as NSString).substringFromIndex(self.scanLocation)

        if (string.isEmpty) {
            return nil
        }

        let originalScanLocation = self.scanLocation

        let scanner = NSScanner(string: string)
        scanner.charactersToBeSkipped = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var ret: Polynomial! = nil

        let operands = NSCharacterSet(charactersInString: "+-*/^")

        var previousOperands = [String]()

        repeat {
            if let term = scanner.scanPolynomialTerm() {
                let poly = Polynomial(term: term)
                switch (previousOperands.popLast() ?? "") {
                case "+":
                    ret = Polynomial(function: Addition(terms: [ret, poly])).simplify()
                case "-":
                    ret = Polynomial(function: Subtraction(terms: [ret, poly])).simplify()
                case "*":
                    ret = Polynomial(function: Multiplication(terms: [ret, poly])).simplify()
                case "/":
                    ret = Polynomial(function: Division(terms: [ret, poly])).simplify()
                case "^":
                    ret = Polynomial(function: Exponentiation(terms: [ret, poly])).simplify()
                case "":
                    ret = poly
                default:
                    break
                }
            }

            var nillableOperand : NSString? = nil
            if scanner.scanCharactersFromSet(operands, intoString: &nillableOperand) {
                if let operandNSString = nillableOperand {
                    previousOperands.append(String(operandNSString))
                }
            }

            if scanner.scanString("(", intoString: nil) {
                let substring = (string as NSString).substringFromIndex(scanner.scanLocation)
                let subscanner = NSScanner(string: substring)
                if let poly = subscanner.scanPolynomial() {
                    switch (previousOperands.popLast() ?? "") {
                    case "+":
                        ret = Polynomial(function: Addition(terms: [ret, poly])).simplify()
                    case "-":
                        ret = Polynomial(function: Subtraction(terms: [ret, poly])).simplify()
                    case "*":
                        ret = Polynomial(function: Multiplication(terms: [ret, poly])).simplify()
                    case "/":
                        ret = Polynomial(function: Division(terms: [ret, poly])).simplify()
                    case "^":
                        ret = Polynomial(function: Exponentiation(terms: [ret, poly])).simplify()
                    case "":
                        ret = poly
                    default:
                        break
                    }
                }
                scanner.scanLocation += subscanner.scanLocation
            }

            if scanner.scanString(")", intoString: nil) {
                self.scanLocation = originalScanLocation + scanner.scanLocation
                return ret
            }
        }
        while !scanner.atEnd

        self.scanLocation = originalScanLocation + scanner.scanLocation

        return ret.simplify()
    }
}