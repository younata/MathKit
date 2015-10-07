import Cocoa
import XCTest

class VectorPerformance: XCTestCase {
    
    let p = SimplePolynomial(string: "2x + y")
    let v = Vector(polynomials: ["x": SimplePolynomial(string: "2x + 1"), "y": SimplePolynomial(string: "2x + y")])
    
    func testScalarAdditionPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v + self.p
            }
        }
    }
    
    func testScalarSubtractionPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v - self.p
            }
        }
    }
    
    func testScalarMultiplicationPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v * self.p
            }
        }
    }
    
    func testAddVarByScalarPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v.addScalar(self.p, to: "x")
            }
        }
    }
    
    func testSubtractVarByScalarPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v.subtractScalar(self.p, from: "x")
            }
        }
    }
    
    func testMultiplyVarByScalarPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v.multiplyScalar(self.p, on: "x")
            }
        }
    }
    
    func testVectorAdditionPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v + self.v
            }
        }
    }
    
    func testVectorSubtractionPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v - self.v
            }
        }
    }
    
    func testVectorMultiplicationPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v * self.v
            }
        }
    }
    
    func testDotProductPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
                self.v.dotProduct(self.v)
            }
        }
    }
    
    /*
    
    func testGradientPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
            }
        }
    }
    
    func testDivergencePerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
            }
        }
    }
    
    func testCurlPerformance() {
        self.measureBlock() {
            for i in 0..<1000 {
            }
        }
    }*/
}
