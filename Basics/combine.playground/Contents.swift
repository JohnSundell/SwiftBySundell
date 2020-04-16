// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/combine
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit
import Combine
import PlaygroundSupport

// This playground will execute indefinetly in order to give our
// async operations enough time to execute.
PlaygroundPage.current.needsIndefiniteExecution = true

// --- Creating a publisher for performing a network request ---

let url = URL(string: "https://api.github.com/repos/johnsundell/publish")!
let publisher = URLSession.shared.dataTaskPublisher(for: url)

// --- Subscribing to our publisher ---

struct Repository: Codable {
    var name: String
    var url: URL
}

let cancellable = publisher.sink(
    receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            print(error)
        case .finished:
            print("Success")
        }
    },
    receiveValue: { value in
        let decoder = JSONDecoder()

        do {
            // Since each value passed into our closure will be a tuple
            // containing the downloaded data, as well as the network
            // response itself, we're accessing the 'data' property here:
            let repo = try decoder.decode(Repository.self, from: value.data)
            print(repo)
        } catch {
            print(error)
        }
    }
)

// --- Constructing a reactive chain of operators ---

let repoPublisher = publisher
    .map(\.data)
    .decode(
        type: Repository.self,
        decoder: JSONDecoder()
    )
    .receive(on: RunLoop.main)

// --- Updating our UI based on our reactive chain ---

// Two labels that we want to render our data using:
let nameLabel = UILabel()
let errorLabel = UILabel()

let cancellable2 = repoPublisher.sink(
    receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            // Rendering a description of the error that was encountered:
            errorLabel.text = error.localizedDescription
        case .finished:
            break
        }
    },
    receiveValue: { repo in
        // Rendering the downloaded repository's name:
        nameLabel.text = repo.name
    }
)

/// --- A Counter class with basic Combine support ---

class Counter {
    let publisher = PassthroughSubject<Int, Never>()

    private(set) var value = 0 {
        // Whenever our property was set, we send its new value
        // to our subject/publisher:
        didSet { publisher.send(value) }
    }

    func increment() {
        value += 1
    }
}

/// --- Subscribing to our new publisher ---

let counter = Counter()

let cancellable3 = counter.publisher
    .filter { $0 > 2 }
    .sink { value in
        print(value)
    }

// Since we're filtering out all values below 3, only our final
// increment call will result in a value being printed:
counter.increment()
counter.increment()
counter.increment()

/// --- Our publisher is currently externally mutable, which isn't great ---

counter.publisher.send(17)

/// --- A new version of Counter, which is only mutable internally ---

class Counter2 {
    var publisher: AnyPublisher<Int, Never> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        subject.eraseToAnyPublisher()
    }

    private(set) var value = 0 {
        didSet { subject.send(value) }
    }

    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let subject = PassthroughSubject<Int, Never>()

    func increment() {
        value += 1
    }
}
