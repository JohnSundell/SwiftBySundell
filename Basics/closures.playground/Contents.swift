// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/closures
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit

// --- Examples of how closure types can be declared ---

struct IntToStringConverter {
    // A closure property that takes an Int as input
    // and produces a String as output:
    var body: (Int) -> String
}

// A closure defined as an inline variable, which
// takes no input and produces an Int as output:
let intProvider: () -> Int = { return 7 }

// A closure function argument that takes no input
// and also doesn't produce any output:
func performOperation(then closure: () -> Void) {
    closure()
}

// --- Transforming the words within a string using a closure ---

extension String {
    func transformWords(
        using closure: (Substring) -> String
    ) -> String {
        // Split the current string up into word substrings:
        let words = split(separator: " ")
        var results = [String]()

        // Iterate through each word and transform it:
        for word in words {
            // We can call the closure that was passed into our
            // function just like how we'd call a function:
            let transformed = closure(word)
            results.append(transformed)
        }

        // Join our results array back into a string:
        return results.joined(separator: " ")
    }
}

// --- Calling the above function using different variants of closure syntax ---

let string = "Hello, world!".transformWords(using: { word in
    return word.lowercased()
})

print(string) // "hello, world!"

let string2 = "Hello, world!".transformWords {
    $0.lowercased()
}

// --- Improving our function using map ---

extension String {
    func transformWordsUsingMap(
        using closure: (Substring) -> String
    ) -> String {
        let words = split(separator: " ")
        let results = words.map(closure)
        return results.joined(separator: " ")
    }
}

// --- Requiring a closure to be escaping, since it'll be stored ---

func delay(by seconds: TimeInterval,
           on queue: DispatchQueue = .main,
           closure: @escaping () -> Void) {
    queue.asyncAfter(
        deadline: .now() + seconds,
        execute: closure
    )
}

// --- Requiring 'self' to be used within escaping closures ---

class ProfileViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        delay(by: 2) { [weak self] in
            // We need to use 'self' here to be able to call our
            // method, since we're inside an escaping closure.
            self?.showTutorialIfNeeded()
        }
    }

    private func showTutorialIfNeeded() {
        print("Showing tutorial")
    }
}

// --- Passing a function as a closure ---

func capitalize(word: Substring) -> String {
    return word.capitalized
}

let name = "swift by sundell".transformWords(using: capitalize)
print(name) // "Swift By Sundell"
