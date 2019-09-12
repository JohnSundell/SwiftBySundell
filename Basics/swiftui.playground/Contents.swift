// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/swiftui
// (c) 2019 John Sundell
// Licensed under the MIT license

import SwiftUI
import UIKit
import PlaygroundSupport

// --- The product model that our app is using ---

struct Product {
    var name: String
    var image: UIImage
    var price: String
}

// --- A view that displays a linear gradient from red to blue ---

struct ProductGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.red, .blue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).edgesIgnoringSafeArea(.all)
    }
}

// --- A view that displays information about a product ---

struct ProductInfoView: View {
    var product: Product

    var body: some View {
        VStack {
            Image(uiImage: product.image)

            HStack {
                Text(product.name).bold().lineLimit(2)
                Text(product.price).foregroundColor(.white)
            }
        }
    }
}

// --- Our main product view that composes all our subviews ---

struct ProductView: View {
    var product: Product

    @State private var quantity = 1

    var body: some View {
        ZStack {
            ProductGradientView()

            VStack {
                ProductInfoView(product: product)

                Stepper("Quantity: \(quantity)",
                    value: $quantity,
                    in: 1...99
                ).padding()
            }
        }
    }
}

// --- Rendering our UI ---

let image = UIImage(systemName: "paperplane.fill")!
let product = Product(name: "Paper plane", image: image, price: "$999")
let view = ProductView(product: product)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)
