// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/strings
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit

// --- Creating a string using a literal and an array of characters ---

let stringA = "Hello!"
let stringB = String(["H", "e", "l", "l", "o", "!"])
print(stringA == stringB) // true

// --- Iterating over all of the characters within a string ---

func printCharacters(in string: String) {
    for character in stringA {
        print(character)
    }
}

printCharacters(in: "Hello, world!")

// --- Extracting all of a character's strings using map ---

func characters(in string: String) -> [Character] {
    return string.map { $0 }
}

characters(in: "Swift by Sundell")

// --- We can't subscript a string using Int indexes ---

let string = "Hello, world!"
// let character = string[1] <- Compiler error

// --- The difference between a string's characters and UTF-8 code units ---

"Café".count // 4
"Café".utf8.count // 5

"👨‍👩‍👧‍👦".count // 1
"👨‍👩‍👧‍👦".utf8.count // 25

// --- Using String.Index ---

let secondIndex = string.index(after: string.startIndex)
let thirdIndex = string.index(string.startIndex, offsetBy: 2)
let lastIndex = string.index(before: string.endIndex)

print(string[secondIndex]) // e
print(string[thirdIndex]) // l
print(string[lastIndex]) // !

// --- Extracting substrings using String.Index ranges ---

let range = secondIndex..<lastIndex
let substring = string[range]
print(substring) // ello, world

// --- Substrings are not proper strings, unless we convert them ---

let label = UILabel()
// label.text = substring <- Compiler error
label.text = String(substring)

// --- Both String and Substring conform to StringProtocol

func letters<S: StringProtocol>(in string: S) -> [Character] {
    return string.filter { $0.isLetter }
}

letters(in: string)
letters(in: substring)
