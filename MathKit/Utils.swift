import Foundation

public func cont<T: Equatable>(arr: [T], obj: T) -> Bool {
    for itm in arr {
        if itm == obj {
            return true
        }
    }
    return false
}

public func reduceTerms(var terms: [PolynomialTerm]) -> [PolynomialTerm] {
    if terms.count > 1 {
        for (i,x) in terms.enumerate() {
            if i >= terms.count {
                break
            }
            for (j,y) in terms[(i + 1)..<terms.count].enumerate() {
                if i == j {
                    continue
                }
                if let res = x.add(y) {
                    terms.removeAtIndex(j)
                    terms[i] = res
                    break
                }
            }
        }
    }
    let prototype : [PolynomialTerm] = []
    return terms.reduce(prototype) {
        if $1 == PolynomialTerm() {
            return $0
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