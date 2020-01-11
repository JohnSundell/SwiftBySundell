// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/access-control
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit

// Defining a type and method without any specific level of
// access control, making them 'internal':

class PriceCalculator {
    func calculatePrice(for products: [Product]) -> Int {
        // The reduce function enables us to reduce a collection,
        // in this case an array of products, into a single value:
        products.reduce(into: 0) { totalPrice, product in
            totalPrice += product.price
        }
    }
}

// Making our above class, and its method, public instead (note that
// the change in name is only to make this playground compile):

public class PublicPriceCalculator {
    public init() {}

    public func calculatePrice(for products: [Product]) -> Int {
        products.reduce(into: 0) { totalPrice, product in
            totalPrice += product.price
        }
    }
}

// Subclassing an 'open' class defined within another module
// (see 'OpenPriceCalculator' within Accessories.swift):

class DiscountedPriceCalculator: PriceCalculator {
    fileprivate let discount: Int

    init(discount: Int) {
        self.discount = discount
        super.init()
    }

    override func calculatePrice(for products: [Product]) -> Int {
        let price = super.calculatePrice(for: products)
        return price - discount
    }
}

// Since our price calculator's 'discount' property is
// 'fileprivate', we're able to access it within related
// code defined within this file:

extension UIAlertController {
    func showPriceDescription(
        for products: [Product],
        in viewController: UIViewController,
        calculator: DiscountedPriceCalculator
    ) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        let price = calculator.calculatePrice(for: products)

        // We can now access 'discount' even outside of the type
        // that it's declared in, thanks to 'fileprivate':
        alert.message = """
        Your \(products.count) product(s) will cost \(price).
        Including a discount of \(calculator.discount).
        """

        viewController.present(alert, animated: true)
    }
}
