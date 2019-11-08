// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/enums
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit

// --- Declaring and using an enum without a raw value type ---

enum ContactType {
    case friend
    case family
    case coworker
    case businessPartner
}

func iconName(forContactType type: ContactType) -> String {
    switch type {
    case .friend:
        return "friend"
    case .family:
        return "family"
    case .coworker:
        return "coworker"
    case .businessPartner:
        return "business_partner"
    }
}

// --- Declaring and using an enum that can be represented by a String ---

// By adding ": String" after its name, we've now made our enum
// representable by a raw value, String in this case:
enum ContactType2: String {
    case friend
    case family
    case coworker
    // We can also customize what exact raw value we want a
    // case to be represented by (the default will match the
    // case's name for strings, and its index for integers):
    case businessPartner = "business_partner"
}

func iconName2(forContactType type: ContactType2) -> String {
    return type.rawValue
}

// A valid raw value will be matched to its corresponding case,
// while an invalid one will result in 'nil':
let valid = ContactType2(rawValue: "coworker") // .coworker
let invalid = ContactType2(rawValue: "unknown") // nil

// --- Using associated values ---

enum ReadState {
    // The user hasn't started reading the book yet:
    case unread
    // The user is currently reading the book at a
    // given page number:
    case inProgress(pageNumber: Int)
    // The user has finished reading the book, and gave it
    // a given rating once done:
    case finished(rating: Rating)
}

func restore(fromState state: ReadState) {
    switch state {
    case .unread:
        openBook()
    case .inProgress(let pageNumber):
        openBook()
        turnToPage(number: pageNumber)
    case .finished(let rating):
        displayRating(rating)
    }
}

// --- Declaring enum values ---

restore(fromState: .unread)
restore(fromState: .inProgress(pageNumber: 5))

struct BookSession {
    var book: Book
    var readState: ReadState = .unread
}
