// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/unit-testing
// (c) 2019 John Sundell
// Licensed under the MIT license

import XCTest

// --- Testing mutating a model ---

extension Product {
    mutating func apply(_ coupon: Coupon) {
        let multiplier = 1 - coupon.discount / 100
        price *= multiplier
    }
}

class ProductTests: XCTestCase {
    func testApplyingCoupon() {
        // Given
        var product = Product(name: "Book", price: 25)
        let coupon = Coupon(name: "Holiday Sale", discount: 20)

        // When
        product.apply(coupon)

        // Then
        XCTAssertEqual(product.price, 20)
    }
}

// --- Using a test case's setUp method ---

class ShoppingCartTests: XCTestCase {
    // Normally, it can be argued that force unwrapping (!) should
    // be avoided, but in unit tests it can be a good idea for
    // properties (only!) in order to avoid unnecessary boilerplate.
    private var shoppingCart: ShoppingCart!

    override func setUp() {
        super.setUp()
        // Using this, a new instance of ShoppingCart will be created
        // before each test is run.
        shoppingCart = ShoppingCart()
    }

    func testCalculatingTotalPrice() {
        // Given: Here we assert that our initial state is correct
        XCTAssertEqual(shoppingCart.totalPrice, 0)

        // When
        shoppingCart.add(Product(name: "Book", price: 20))
        shoppingCart.add(Product(name: "Movie", price: 15))

        // Then
        XCTAssertEqual(shoppingCart.totalPrice, 35)
    }
}

// --- Running all of our unit tests within the playground ---

// Check Xcode's console for details
XCTestSuite.default.run()
