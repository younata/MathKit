import Foundation

public struct Logarithm: Function, Equatable {
    public var description: String {
        return ""
    }

    public var latexDescription: String {
        return self.description
    }

    public var numberOfInputs: Int { return 2 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        return nil
    }

    public func valueAt(x: [String : Double]) -> Double? {
        return nil
    }

    public func differentiate(respectTo: String) -> Polynomial? {
        return nil
    }

    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}

public func ==(a: Logarithm, b: Logarithm) -> Bool {
    return  false
}

public struct NaturalLogarithm: Function {
    public var description: String {
        return ""
    }

    public var latexDescription: String {
        return self.description
    }

    public var numberOfInputs: Int { return 1 }
    public private(set) var terms: [Polynomial]

    public init(terms: [Polynomial]) {
        self.terms = terms
        assert(terms.count == self.numberOfInputs)
    }

    public func simplify() -> Polynomial? {
        return nil
    }

    public func valueAt(x: [String : Double]) -> Double? {
        return nil
    }

    public func differentiate(respectTo: String) -> Polynomial? {
        return nil
    }

    public func integrate(respectTo: String) -> Polynomial? {
        return nil
    }
}