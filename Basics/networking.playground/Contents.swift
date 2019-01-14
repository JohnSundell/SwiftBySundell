// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/networking
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit
import PlaygroundSupport

// -- Using URLComponents to construct a URL --

var components = URLComponents()
components.scheme = "https"
components.host = "api.github.com"
components.path = "/users/johnsundell"

guard let url = components.url else {
    preconditionFailure("Failed to construct URL")
}

// -- Creating a label to display our result in --

let label = UILabel()
label.textColor = .white
label.numberOfLines = 0
label.frame.size = CGSize(width: 300, height: 300)
PlaygroundPage.current.liveView = label

// -- Creating a URLSession data task to perform a request --

let task = URLSession.shared.dataTask(with: url) {
    data, response, error in

    DispatchQueue.main.async {
        if let data = data {
            label.text = String(decoding: data, as: UTF8.self)
        } else {
            label.text = error?.localizedDescription
        }
    }
}

// -- Starting the request --

task.resume()
