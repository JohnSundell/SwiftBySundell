// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/error-handling
// (c) 2019 John Sundell
// Licensed under the MIT license

// Note: This playground uses Swift 5

import UIKit

// --- Defining an error enum ---

enum ValidationError: Error {
    case tooShort
    case tooLong
    case invalidCharacterFound(Character)
}

// --- Localizing our error type ---

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .tooShort:
            return NSLocalizedString(
                "Your username needs to be at least 4 characters long",
                comment: ""
            )
        case .tooLong:
            return NSLocalizedString(
                "Your username can't be longer than 14 characters",
                comment: ""
            )
        case .invalidCharacterFound(let character):
            let format = NSLocalizedString(
                "Your username can't contain the character '%@'",
                comment: ""
            )

            return String(format: format, String(character))
        }
    }
}

// --- Using our error type to build a synchronous validator ---

func validate(username: String) throws {
    guard username.count > 3 else {
        throw ValidationError.tooShort
    }

    guard username.count < 15 else {
        throw ValidationError.tooLong
    }

    for character in username {
        guard character.isLetter else {
            throw ValidationError.invalidCharacterFound(character)
        }
    }
}

// --- Error label and stub submit function used for demo purposes ---

let errorLabel = UILabel()
func submit(_ username: String) {}

// --- Using our validate function from above, and displaying any thrown error ---

func userDidPickName(_ username: String) {
    do {
        try validate(username: username)
        submit(username)
    } catch {
        errorLabel.text = error.localizedDescription
    }
}

// --- Asynchronous version of our previous validation function ---

func validate(username: String,
              then handler: @escaping (Error?) -> Void) {
    DispatchQueue.main.async {
        do {
            try validate(username: username)
            handler(nil)
        } catch {
            handler(error)
        }
    }
}

// --- Using our async validation function ---

class AsyncValidation {
    func userDidPickName(_ username: String) {
        validate(username: username) { error in
            if let error = error {
                errorLabel.text = error.localizedDescription
            } else {
                submit(username)
            }
        }
    }
}

// --- Triggering the above code ----

userDidPickName("john-sundell")
errorLabel.text
AsyncValidation().userDidPickName("john-sundell")
