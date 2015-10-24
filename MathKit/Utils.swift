import Foundation

public func cont<T: Equatable>(arr: [T], obj: T) -> Bool {
    for itm in arr {
        if itm == obj {
            return true
        }
    }
    return false
}

internal func reducePolynomialTerms(terms: [PolynomialTerm]) -> [PolynomialTerm] {
    return terms.reduce([PolynomialTerm]()) {
        for (idx, term) in $0.enumerate() {
            if term.degree == $1.degree {
                var array = $0
                array[idx] = term + $1
                return array
            }
        }
        return $0 + [$1]
    }
}

public func condenseTerms(terms: [PolynomialTerm]?, at: [String: Double]) -> Double? {
    if let theTerms = terms {
        var ret : Double = 0
        for term in theTerms {
            if let v = term.valueAt(at) {
                ret += v
            } else {
                return nil
            }
        }
        return ret
    }
    return nil
}

infix operator ** { associativity left precedence 160 }

infix operator **= { associativity right precedence 90 }