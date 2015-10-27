import Foundation
import XCTest
import MathKit

class PolynomialPerformance: XCTestCase {

    let t0 = PolynomialTerm(coefficient: 1.0, variables: [:])
    let t1 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0])
    let t2 = PolynomialTerm(coefficient: 3.0, variables: ["x": 2.0])
    
    let y2 = PolynomialTerm(coefficient: 3.0, variables: ["y": 2.0])
    
    let mt1 = PolynomialTerm(coefficient: 1.0, variables: ["x": 1.0, "y": 1.0])
    let mt2 = PolynomialTerm(coefficient: 2.0, variables: ["x": 1.0, "y": 1.0])
    
    var p1 = Polynomial()
    var p2 = Polynomial()
    var p3 = Polynomial()
    var p4 = Polynomial()
    var p5 = Polynomial()
    
    override func setUp() {
        super.setUp()
        
        p1 = Polynomial(terms: [t0])
        p2 = Polynomial(terms: [t1, t0])
        p3 = Polynomial(terms: [mt1, y2])
        p4 = Polynomial(terms: [t1, mt1, y2])
        p5 = Polynomial(terms: [t2, y2])
    }
    
    func testInitializationStringPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                let _ = Polynomial(string: "2x + x^1y^1 + 3y^2")
            }
        }
    }
    
    func testValueAtPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p5.valueAt(["x": 4.0, "y": 10.0])
            }
        }
    }
    
    func testPolynomialAdditionPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 + self.p5
            }
        }
    }
    
    func testScalarAdditionPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 + 30
            }
        }
    }
    
    func testPolynomialSubtractionPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 - self.p3
            }
        }
    }
    
    func testScalarSubtractionPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 - 30
            }
        }
    }
    
    func testPolynomialMultiplicationPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 * self.p5
            }
        }
    }
    
    func testScalarMultiplicationPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 * 30
            }
        }
    }
    
    func testScalarDivisionPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4 / 30
            }
        }
    }
    
    func testDifferentationPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4.differentiate("y")
            }
        }
    }
    
    func testGradientPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p5.gradient()
            }
        }
    }
    
    func testIntegrationPerformance() {
        self.measureBlock {
            for _ in 0..<1000 {
                self.p4.integrate("x")
            }
        }
    }
    
//    func testIntegrationRangePerformance() {
//        self.measureBlock {
//            for _ in 0..<1000 {
//                self.p5.integrate("x", over: (1, 2))
//            }
//        }
//    }
//    
//    func testFindRootsLinearPerformance() {
//        let q = Polynomial(string: "2x - 1")
//        self.measureBlock {
//            for _ in 0..<1000 {
//                q.solve()
//            }
//        }
//    }
//    
//    func testFindRootsQuadraticPerformance() {
//        let q = Polynomial(string: "4x^2 + 2x - 1")
//        self.measureBlock {
//            for _ in 0..<1000 {
//                q.solve()
//            }
//        }
//    }
//    
//    func testCompositionPerformance() {
//        self.measureBlock {
//            for _ in 0..<1000 {
//                self.p4.of(self.p5, at: "x")
//            }
//        }
//    }
}
