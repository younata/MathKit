import Cocoa
import XCTest

class SimplePolynomialPerformance: XCTestCase {

    let t0 = PolynomialTerm(coefficient: 1.0, variables: [:])
    let t1 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0])
    let t2 = PolynomialTerm(coefficient: 3.0, variables: ["x": 2.0])
    
    let y2 = PolynomialTerm(coefficient: 3.0, variables: ["y": 2.0])
    
    let mt1 = PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0, "y": 1.0])
    let mt2 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0, "y": 1.0])
    
    var p1 = SimplePolynomial()
    var p2 = SimplePolynomial()
    var p3 = SimplePolynomial()
    var p4 = SimplePolynomial()
    var p5 = SimplePolynomial()
    
    override func setUp() {
        super.setUp()
        
        p1 = SimplePolynomial(terms: [t0])
        p2 = SimplePolynomial(terms: [t1, t0])
        p3 = SimplePolynomial(terms: [mt1, y2])
        p4 = SimplePolynomial(terms: [t1, mt1, y2])
        p5 = SimplePolynomial(terms: [t2, y2])
    }
    
    func testInitializationStringPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                SimplePolynomial(string: "2x + x^1y^1 + 3y^2")
            }
        }
    }
    
    func testValueAtPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p5.valueAt(["x": 4.0, "y": 10.0])
            }
        }
    }
    
    func testPolynomialAdditionPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 + self.p5
            }
        }
    }
    
    func testScalarAdditionPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 + 30
            }
        }
    }
    
    func testPolynomialSubtractionPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 - self.p3
            }
        }
    }
    
    func testScalarSubtractionPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 - 30
            }
        }
    }
    
    func testPolynomialMultiplicationPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 * self.p5
            }
        }
    }
    
    func testScalarMultiplicationPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 * 30
            }
        }
    }
    
    func testScalarDivisionPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4 / 30
            }
        }
    }
    
    func testDifferentationPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.differentiate("y")
            }
        }
    }
    
    func testGradientPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p5.gradient()
            }
        }
    }
    
    func testIntegrationPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.integrate("x")
            }
        }
    }
    
    func testIntegrationRangePerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p5.integrate("x", over: (1, 2))
            }
        }
    }
    
    func testFindRootsLinearPerformance() {
        let q = SimplePolynomial(string: "2x - 1")
        self.measureBlock {
            for i in 0..<1000 {
                q.solve()
            }
        }
    }
    
    func testFindRootsQuadraticPerformance() {
        let q = SimplePolynomial(string: "4x^2 + 2x - 1")
        self.measureBlock {
            for i in 0..<1000 {
                q.solve()
            }
        }
    }
    
    func testCompositionPerformance() {
        self.measureBlock {
            for i in 0..<1000 {
                self.p4.of(self.p5, at: "x")
            }
        }
    }
}
