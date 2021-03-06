import XCTest
import MathKit

private let p1 = Polynomial(terms: [PolynomialTerm(string: "0.5x^2"), PolynomialTerm(string: "1")])
private let p2 = Polynomial(terms: [PolynomialTerm(string: "2x"), PolynomialTerm(string: "2")])

class AdditionTests: XCTestCase {
    var subject: Addition! = nil
    override func setUp() {
        super.setUp()

        subject = Addition(terms: [p1, p2])
    }

    func testTerms() {
        XCTAssertEqual(subject.terms, [p1, p2])
    }

    func testDescription() {
        XCTAssertEqual(subject.description, "(0.5(x^2.0) + 1.0) + (2.0(x) + 2.0)")
    }

    func testLatexDescription() {
        XCTAssertEqual(subject.latexDescription, "(0.5(x^2.0) + 1.0) + (2.0(x) + 2.0)")
    }

    func testEquatable() {
        XCTAssertEqual(subject, Addition(terms: [p1, p2]))
        XCTAssertEqual(subject, Addition(terms: [p2, p1]))
        XCTAssertNotEqual(subject, Addition(terms: [p1, p1]))
    }

    func testNumberOfInputs() {
        XCTAssertEqual(subject.numberOfInputs, 2)
    }

    func testSimplify() {
        XCTAssertEqual(subject.simplify(), Polynomial(terms: [PolynomialTerm(string: "0.5x^2"), PolynomialTerm(string: "2x"), PolynomialTerm(string: "3")]))

        let a = Addition(terms: [p1, Polynomial(function: subject)])
        XCTAssertEqual(a.simplify(), Polynomial(terms: [PolynomialTerm(string: "x^2"), PolynomialTerm(string: "2x"), PolynomialTerm(string: "4")]))
    }

    func testValueAt() {
        let terms: [String: Double] = ["x": 3.0]
        XCTAssertEqual(subject.valueAt(terms), 13.5)
    }

    func testDifferentiate() {
        XCTAssertEqual(subject.differentiate("a"), Polynomial(terms: []))

        let dp1 = Polynomial(terms: [PolynomialTerm(string: "x")])
        let dp2 = Polynomial(terms: [PolynomialTerm(string: "2")])
        let differentiated = Polynomial(function: Addition(terms: [dp1, dp2]))
        XCTAssertEqual(subject.differentiate("x"), differentiated)
    }

    func testIntegrate() {
        let f = Polynomial(terms: [PolynomialTerm(string: "0.5(x^2)(a)"), PolynomialTerm(string: "2(x)(a)"), PolynomialTerm(string: "3a")])
        XCTAssertEqual(subject.integrate("a"), f)

        XCTAssertEqual(subject.integrate("x"), Polynomial(terms: [PolynomialTerm(string: "0.166666666666667x^3"), PolynomialTerm(string: "x^2"), PolynomialTerm(string: "3x")]))
        XCTAssertEqual(subject.integrate("x")?.differentiate("x"), Polynomial(function: subject))
    }
}

class SubtractionTests: XCTestCase {
    var subject: Subtraction! = nil

    override func setUp() {
        super.setUp()

        subject = Subtraction(terms: [p1, p2])
    }

    func testTerms() {
        XCTAssertEqual(subject.terms, [p1, p2])
    }

    func testDescription() {
        XCTAssertEqual(subject.description, "(0.5(x^2.0) + 1.0) - (2.0(x) + 2.0)")
    }

    func testLatexDescription() {
        XCTAssertEqual(subject.latexDescription, "(0.5(x^2.0) + 1.0) - (2.0(x) + 2.0)")
    }

    func testEquatable() {
        XCTAssertEqual(subject, Subtraction(terms: [p1, p2]))
        XCTAssertNotEqual(subject, Subtraction(terms: [p2, p1]))
    }

    func testNumberOfInputs() {
        XCTAssertEqual(subject.numberOfInputs, 2)
    }

    func testSimplify() {
        XCTAssertEqual(subject.simplify(), Polynomial(terms: [PolynomialTerm(string: "0.5x^2"), PolynomialTerm(string: "-2x"), PolynomialTerm(string: "-1")]))
    }

    func testValueAt() {
        let terms: [String: Double] = ["x": 3.0]
        XCTAssertEqual(subject.valueAt(terms), -2.5)
    }

    func testDifferentiate() {
        XCTAssertEqual(subject.differentiate("a"), Polynomial.zero())

        let dp1 = Polynomial(terms: [PolynomialTerm(string: "x")])
        let dp2 = Polynomial(terms: [PolynomialTerm(string: "2")])
        let differentiated = Polynomial(function: Subtraction(terms: [dp1, dp2]))
        XCTAssertEqual(subject.differentiate("x"), differentiated)
    }

    func testIntegrate() {
        let f = Polynomial(terms: [PolynomialTerm(string: "0.5(x^2)(a)"), PolynomialTerm(string: "-2(x)(a)"), PolynomialTerm(string: "-1a")])
        XCTAssertEqual(subject.integrate("a"), f)

        let integrated = Polynomial(terms: [PolynomialTerm(string: "0.1666666666666666667x^3"), PolynomialTerm(string: "-1x^2"), PolynomialTerm(string: "-1x")])
        XCTAssertEqual(subject.integrate("x"), integrated)

        XCTAssertEqual(subject.integrate("x")?.differentiate("x"), Polynomial(function: subject))
    }
}

class MultiplicationTests: XCTestCase {
    var subject: Multiplication! = nil

    override func setUp() {
        super.setUp()

        subject = Multiplication(terms: [p1, p2])
    }

    func testTerms() {
        XCTAssertEqual(subject.terms, [p1, p2])
    }

    func testDescription() {
        XCTAssertEqual(subject.description, "(0.5(x^2.0) + 1.0) * (2.0(x) + 2.0)")
    }

    func testLatexDescription() {
        XCTAssertEqual(subject.latexDescription, "(0.5(x^2.0) + 1.0) * (2.0(x) + 2.0)")
    }

    func testEquatable() {
        XCTAssertEqual(subject, Multiplication(terms: [p1, p2]))
        XCTAssertEqual(subject, Multiplication(terms: [p2, p1]))
        XCTAssertNotEqual(subject, Multiplication(terms: [p1, p1]))
    }

    func testNumberOfInputs() {
        XCTAssertEqual(subject.numberOfInputs, 2)
    }

    func testSimplify() {
        XCTAssertEqual(subject.simplify(), Polynomial(terms: [PolynomialTerm(string: "x^3"), PolynomialTerm(string: "x^2"), PolynomialTerm(string: "2x"), PolynomialTerm(string: "2")]))
    }

    func testValueAt() {
        let terms: [String: Double] = ["x": 3.0]
        XCTAssertEqual(subject.valueAt(terms), 44)
    }

    func testDifferentiate() {
        XCTAssertEqual(subject.differentiate("a"), Polynomial.zero())

        let differentiated = Polynomial(terms: [PolynomialTerm(string: "3x^2"), PolynomialTerm(string: "2x"), PolynomialTerm(string: "2")])
        XCTAssertEqual(subject.differentiate("x"), differentiated)
    }

    func testIntegrate() {
        XCTAssertEqual(subject.integrate("a"), Polynomial(terms: [PolynomialTerm(string: "(a)x^3"), PolynomialTerm(string: "(a)x^2"), PolynomialTerm(string: "2(a)(x)"), PolynomialTerm(string: "2a")]))

        let integrated = Polynomial(terms: [PolynomialTerm(string: "0.25x^4"), PolynomialTerm(string: "0.3333x^3"), PolynomialTerm(string: "x^2"), PolynomialTerm(string: "2x")])
        XCTAssertEqual(subject.integrate("x"), integrated)

        XCTAssertEqual(subject.integrate("x")?.differentiate("x"), Polynomial(function: subject))
    }
}

class DivisionTests: XCTestCase {
    var subject: Division! = nil

    override func setUp() {
        super.setUp()

        subject = Division(terms: [p1, p2])
    }

    func testTerms() {
        XCTAssertEqual(subject.terms, [p1, p2])
    }

    func testDescription() {
        XCTAssertEqual(subject.description, "(0.5(x^2.0) + 1.0) / (2.0(x) + 2.0)")
    }

    func testLatexDescription() {
        XCTAssertEqual(subject.latexDescription, "\\frac{(0.5(x^2.0) + 1.0)}{(2.0(x) + 2.0)}")
    }

    func testEquatable() {
        XCTAssertEqual(subject, Division(terms: [p1, p2]))
        XCTAssertNotEqual(subject, Division(terms: [p2, p1]))
    }

    func testNumberOfInputs() {
        XCTAssertEqual(subject.numberOfInputs, 2)
    }

    func testSimplify() {
        let a = Division(terms: [Polynomial(terms: []), Polynomial.one()])
        XCTAssertEqual(a.simplify(), Polynomial.zero())

        let b = Division(terms: [p1 * p1, p1])
        XCTAssertEqual(b.simplify(), p1)

        let c = Division(terms: [p2, p2])
        XCTAssertEqual(c.simplify(), Polynomial.one())

        XCTAssertNil(subject.simplify())
    }

    func testValueAt() {
        let terms: [String: Double] = ["x": 3.0]
        XCTAssertEqual(subject.valueAt(terms), 0.6875)
    }

    func testDifferentiate() {
        XCTAssertEqual(subject.differentiate("a"), Polynomial.zero())

        let differentiatedNum = Polynomial(terms: [PolynomialTerm(string: "x^2"), PolynomialTerm(string: "2x"), PolynomialTerm(string: "-2")])

        let differentiatedDenom = Polynomial(function: Exponentiation(terms: [p2, Polynomial(scalar: 2)]))
        let differentiated = Polynomial(function: Division(terms: [differentiatedNum, differentiatedDenom]))

        XCTAssertEqual(subject.differentiate("x"), differentiated)
    }

    func testIntegrate() {
        XCTFail("Integration")
    }
}

class ExponentiationTests: XCTestCase {
    var subject: Exponentiation! = nil

    override func setUp() {
        super.setUp()

        subject = Exponentiation(terms: [p1, p2])
    }

    func testTerms() {
        XCTAssertEqual(subject.terms, [p1, p2])
    }

    func testDescription() {
        XCTAssertEqual(subject.description, "(0.5(x^2.0) + 1.0) ^ (2.0(x) + 2.0)")
    }

    func testLatexDescription() {
        XCTAssertEqual(subject.latexDescription, "(0.5(x^2.0) + 1.0)^{(2.0(x) + 2.0)}")
    }

    func testEquatable() {
        XCTAssertEqual(subject, Exponentiation(terms: [p1, p2]))
        XCTAssertNotEqual(subject, Exponentiation(terms: [p2, p1]))
    }

    func testNumberOfInputs() {
        XCTAssertEqual(subject.numberOfInputs, 2)
    }

    func testSimplify() {
        XCTAssertNil(subject.simplify())
    }

    func testValueAt() {
        let terms: [String: Double] = ["x": 3.0]
        XCTAssertEqualWithAccuracy(subject.valueAt(terms)!, 837339.37891, accuracy: 1e-5)
    }

    func testDifferentiate() {
        XCTFail()
        //XCTAssertEqual(subject.differentiate("a"), subject)

        //let dp1 = Polynomial(terms: [PolynomialTerm(string: "0.5x^2"), PolynomialTerm(string: "1")])
        //let dp2 = Polynomial(terms: [PolynomialTerm(string: "2x"), PolynomialTerm(string: "2")])
        //let differentiatedTerms = []
        //XCTAssertEqual(subject.differentiate("x"), differentiatedTerms)
    }

    func testIntegrate() {
        XCTFail()
    }
}
