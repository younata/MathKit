import Foundation
import XCTest

class PolynomialTests: XCTestCase {
    
    let sp1 = SimplePolynomial(string: "")
    let sp2 = SimplePolynomial(string: "")
    let sp3 = SimplePolynomial(string: "")
    let sp4 = SimplePolynomial(string: "")
    
    var p1: Polynomial! = nil
    var p2: Polynomial! = nil
    var p3: Polynomial! = nil
    var p4: Polynomial! = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        p1 = Polynomial(simplePolynomial: sp1)
        p2 = Polynomial(stack: [(sp1, nil), (sp2, nil), (nil, Addition())])
        p3 = Polynomial(stack: [(sp2, nil), (sp3, nil), (nil, Multiplication())])
        p4 = Polynomial(stack: [(sp3, nil), (sp4, nil), (nil, Division())])
    }
    
//    func testInitializationNothing() {
//        var p = Polynomial(terms: [PolynomialTerm()])
//        XCTAssert(p.stack == nil, "stack should be nil")
//        XCTAssertEqual(p.terms.count, 0, "should not accept terms with coefficient 0")
//
//        p = Polynomial(simplePolynomial: SimplePolynomial())
//        XCTAssert(p.stack == nil, "stack should be nil")
//        XCTAssertEqual(p.terms.count, 0, "terms should be empty")
//        
//        p = Polynomial(stack: [])
//        XCTAssert(p.stack != nil, "stack should be nil")
//        XCTAssertEqual(p.terms.count, 0, "terms should be empty")
//    }
//    
//    func testInitializationValid() {
//        let pt = PolynomialTerm(coefficient: 1.0, variables: [:])
//        
//        var p = Polynomial(terms: [pt])
//        XCTAssertEqual(p.terms.count, 1, "should init with valid terms")
//        XCTAssert(p.stack == nil, "stack should not yet be initialized")
//        
//        XCTAssertEqual(Polynomial(terms: [PolynomialTerm(string: "2x"), PolynomialTerm(string: "x")]), Polynomial(terms: [PolynomialTerm(string: "3x")]), "add similar terms together")
//        
//        p = Polynomial(simplePolynomial: sp1)
//        XCTAssertEqual(p, sp1, "Initialize with simple polynomial should equal that same polynomial")
//        XCTAssert(p.stack == nil, "stack should not yet be initialized")
//    }
}
