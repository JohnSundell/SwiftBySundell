// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/access-control
// (c) 2020 John Sundell
// Licensed under the MIT license

import Foundation

// Accessories for demo purposes

public struct Product {
    public var price: Int
}

open class OpenPriceCalculator {
    public init() {}

    open func calculatePrice(for products: [Product]) -> Int {
        products.reduce(into: 0) { totalPrice, product in
            totalPrice += product.price
        }
    }
}
