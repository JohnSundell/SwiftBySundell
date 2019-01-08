// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/grand-central-dispatch
// (c) 2019 John Sundell
// Licensed under the MIT license

import Foundation

// Accessories for demo purposes

public struct Item {}

public func findItems(matching query: String) -> [Item] {
    return [Item()]
}

public func loadFiles() -> [Item] {
    return [Item()]
}

public func process(_ items: [Item]) {
    // ...
}

public func loadArticleText() -> String {
    return "Hello, world!"
}
