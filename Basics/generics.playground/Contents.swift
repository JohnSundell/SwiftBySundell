// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/generics
// (c) 2019 John Sundell
// Licensed under the MIT license

import Foundation

// --- Specializing Array for strings ---

var array = ["One", "Two", "Three"]
array.append("Four")

// This won't compile, since the above array is specialized
// for strings, meaning that other values can't be inserted:
// array.append(5)

// As we pull an element out of the array, we can still treat
// it like a normal string, since we have full type safety.
let characterCount = array[0].count

// --- Defining a generic Container type ---

struct Container<Value> {
    var value: Value
    var date: Date
}

// --- Specializing our Container type ---

let stringContainer = Container(value: "Message", date: Date())
let intContainer = Container(value: 7, date: Date())

// --- Creating a generic cache ---

class Cache<Key: Hashable, Value> {
    private var values = [Key: Container<Value>]()

    func insert(_ value: Value, forKey key: Key) {
        let expirationDate = Date().addingTimeInterval(1000)

        values[key] = Container(
            value: value,
            date: expirationDate
        )
    }

    func value(forKey key: Key) -> Value? {
        guard let container = values[key] else {
            return nil
        }

        // If the container's date is in the past, then the
        // value has expired, and we remove it from the cache.
        guard container.date > Date() else {
            values[key] = nil
            return nil
        }

        return container.value
    }
}

// --- Specializing our cache ---

class UserManager {
    private var cachedUsers = Cache<User.ID, User>()
}

class SearchController {
    private var cachedResults = Cache<Query, [SearchResult]>()
}

// --- Extending String with a generic function ---

extension String {
    mutating func appendIDs<T: Identifiable>(of values: [T]) {
        for value in values {
            append(" \(value.id)")
        }
    }
}

// --- Defining a generic protocol ---

protocol Identifiable {
    associatedtype ID: Equatable & CustomStringConvertible

    var id: ID { get }
}

// --- Conforming to our generic protocol ---

struct Article: Identifiable {
    let id: UUID
    var title: String
    var body: String
}

struct Tag: Identifiable {
    let id: Int
    var name: String
}
