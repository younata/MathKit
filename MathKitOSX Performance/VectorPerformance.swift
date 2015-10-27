import Cocoa
import XCTest
import MathKit

class VectorPerformance: XCTestCase {
    
    let p = Polynomial(string: "2x + y")
    let v = Vector(polynomials: ["x": Polynomial(string: "2x + 1"), "y": Polynomial(string: "2x + y")])
    
    func testScalarAdditionPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v + self.p
            }
        }
    }
    
    func testScalarSubtractionPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v - self.p
            }
        }
    }
    
    func testScalarMultiplicationPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v * self.p
            }
        }
    }
    
    func testAddVarByScalarPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v.addScalar(self.p, to: "x")
            }
        }
    }
    
    func testSubtractVarByScalarPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v.subtractScalar(self.p, from: "x")
            }
        }
    }
    
    func testMultiplyVarByScalarPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v.multiplyScalar(self.p, on: "x")
            }
        }
    }
    
    func testVectorAdditionPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v + self.v
            }
        }
    }
    
    func testVectorSubtractionPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v - self.v
            }
        }
    }
    
    func testVectorMultiplicationPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v * self.v
            }
        }
    }
    
    func testDotProductPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
                self.v.dotProduct(self.v)
            }
        }
    }
    
    /*
    
    func testGradientPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
            }
        }
    }
    
    func testDivergencePerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
            }
        }
    }
    
    func testCurlPerformance() {
        self.measureBlock() {
            for _ in 0..<1000 {
            }
        }
    }*/
}
