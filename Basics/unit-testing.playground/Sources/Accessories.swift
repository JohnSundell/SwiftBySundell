// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/unit-testing
// (c) 2019 John Sundell
// Licensed under the MIT license

import Foundation

// Accessories for demo purposes

public struct Product {
    public var name: String
    public var price: Double

    public init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}

public struct Coupon {
    public var name: String
    public var discount: Double

    public init(name: String, discount: Double) {
        self.name = name
        self.discount = discount
    }
}

public class ShoppingCart {
    private var products = [Product]()

    public init() {}

    public func add(_ product: Product) {
        products.append(product)
    }
}

public extension ShoppingCart {
    var totalPrice: Double {
        return products.reduce(0) { $0 + $1.price }
    }
}
