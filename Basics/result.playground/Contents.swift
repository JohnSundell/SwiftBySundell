// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/result
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit
import PlaygroundSupport

// This playground will execute indefinetly, since it includes async code
PlaygroundPage.current.needsIndefiniteExecution = true

// --- Making a network call using the built-in URLSession API ---

let url = URL(string: "https://www.swiftbysundell.com")!

let standardTask = URLSession.shared.dataTask(with: url) {
    data, response, error in

    if let error = error {
        // Handle error (just printing here for demo purposes)
        print(error)
    } else if let data = data {
        // Handle successful response data
        // (just printing here for demo purposes)
        print(data)
    }
}

standardTask.resume()

// --- Extending URLSession with a Result type-based API ---

extension URLSession {
    func dataTask(
        with url: URL,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}

// --- Using our new API ---

let resultTask = URLSession.shared.dataTask(with: url) { result in
    switch result {
    case .success(let data):
        // Handle successful response data
        // (just printing here for demo purposes)
        print(data)
    case .failure(let error):
        // Handle error (just printing here for demo purposes)
        print(error)
    }
}

/// --- Defining a specific error type ---

enum ImageLoadingError: Error {
    case networkFailure(Error)
    case invalidData
}

/// --- Specializing Result using the above error type ---

struct ImageLoader {
    typealias Handler = (Result<UIImage, ImageLoadingError>) -> Void

    var session = URLSession.shared

    func loadImage(at url: URL,
                   then handler: @escaping Handler) {
        let task = session.dataTask(with: url) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    handler(.success(image))
                } else {
                    handler(.failure(.invalidData))
                }
            case .failure(let error):
                handler(.failure(.networkFailure(error)))
            }
        }

        task.resume()
    }
}

/// --- Using the above image loader ---

let imageURL = URL(string: "https://www.swiftbysundell.com/images/logo.png")!
let imageLoader = ImageLoader()

imageLoader.loadImage(at: imageURL) { result in
    switch result {
    case .success(let image):
        // Handle image (just printing here for demo purposes)
        print(image)
    case .failure(.invalidData):
        // Handle an invalid data failure
        // (just printing here for demo purposes)
        print("Invalid data")
    case .failure(.networkFailure(let error)):
        // Handle any network error
        // (just printing here for demo purposes)
        print(error)
    }
}
