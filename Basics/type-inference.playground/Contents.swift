// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/type-inference
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit
import Combine

// --- Declaring a few constants using type inference ---

let number = 42
let string = "Hello, world!"
let array = [1, 1, 2, 3, 5, 8]
let dictionary = ["key": "value"]

// --- Declaring the same constants using manual type annotations ---

let number2: Int = 42
let string2: String = "Hello, world!"
let array2: [Int] = [1, 1, 2, 3, 5, 8]
let dictionary2: [String: String] = ["key": "value"]

// --- An example of calling a function with a type-inferred enum ---

enum ContactKind {
    case family
    case friend
    case coworker
    case acquaintance
}

struct Contact {}

func loadContacts(ofKind kind: ContactKind) -> [Contact] {
    // This is just an example, so an empty array is always returned.
    []
}

let friends = loadContacts(ofKind: .friend)

// --- Referring to a static property using type inference ---

extension URL {
    static var swiftBySundell: URL {
        URL(string: "https://swiftbysundell.com")!
    }
}

let publisher = URLSession.shared.dataTaskPublisher(for: .swiftBySundell)

// --- Using different numeric types ---

let int = 42
let double = 42 as Double
let float: Float = 42
let cgFloat = CGFloat(42)

// --- Extending Bundle with a method for loading and decoding JSON files ---

extension Bundle {
    struct MissingFileError: Error {
        var name: String
    }

    func decodeJSONFile<T: Decodable>(named name: String) throws -> T {
        guard let url = self.url(forResource: name, withExtension: "json") else {
            throw MissingFileError(name: name)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

// -- Decoding a User struct using the above generic method --

struct User: Codable {
    var name: String
    var email: String
    var lastLoginDate: Date
}

// Error: Generic parameter 'T' could not be inferred
// let user1 = try Bundle.main.decodeJSONFile(named: "user-mock")

let user2: User = try Bundle.main.decodeJSONFile(named: "user-mock")
let user3 = try Bundle.main.decodeJSONFile(named: "user-mock") as User

struct MockData {
    var user: User
}

let mockData = try MockData(
    user: Bundle.main.decodeJSONFile(named: "user-mock")
)
