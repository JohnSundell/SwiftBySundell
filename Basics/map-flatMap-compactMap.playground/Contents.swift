// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/map-flatmap-compactmap
// (c) 2019 John Sundell
// Licensed under the MIT license

import Foundation

// --- A function that extracts all hashtags from within a string ---

func hashtags(in string: String) -> [String] {
    let words = string.components(
        separatedBy: .whitespacesAndNewlines
    )

    // Filter lets us remove any elements that don't fit a
    // given requirement, in this case those that don't start
    // with a leading hash character:
    return words.filter { $0.starts(with: "#") }
}

// --- Calling the above function ---

let tags = hashtags(in: "#Swift by Sundell #Basics")
print(tags) // ["#Swift", "#Basics"]

// --- Manually converting all hashtags into lowercase versions ---

var lowercasedTags = [String]()

for tag in tags {
    lowercasedTags.append(tag.lowercased())
}

// --- Using map to perform that conversion instead ---

func hashtagsWithMap(in string: String) -> [String] {
    let words = string.components(
        separatedBy: .whitespacesAndNewlines
    )

    let tags = words.filter { $0.starts(with: "#") }

    // Using 'map' we can convert a sequence of values into
    // a new array of values, using a closure as a transform:
    return tags.map { $0.lowercased() }
}

// --- Calling the above function on an array of strings using map ---

let strings = [
    "I'm excited about #SwiftUI",
    "#Combine looks cool too",
    "This year's #WWDC was amazing"
]

let tagsUsingMap = strings.map { hashtagsWithMap(in: $0) }
print(tagsUsingMap) // [["#swiftui"], ["#combine"], ["#wwdc"]]

// --- Passing our 'hashtags' function directly to map ---

strings.map(hashtags)

// --- Using flatMap to flatten the result of map ---

let tagsUsingFlatMap = strings.flatMap(hashtagsWithMap)
print(tagsUsingFlatMap) // ["#swiftui", "#combine", "#wwdc"]

// --- Converting an array of strings into ints using compactMap ---

let numbers = ["42", "19", "notANumber"]
let ints = numbers.compactMap { Int($0) }
print(ints) // [42, 19]

// --- Passing Int.init directly to compactMap ---

numbers.compactMap(Int.init)

// --- Using compactMap on an optional ---

func convertToInt(_ string: String?) -> Int? {
    return string.flatMap(Int.init)
}

convertToInt("7")

// --- Using map on an optional with a default value ---

func convertToIntOrUseDefault(_ string: String?) -> Int? {
    return string.map { Int($0) ?? 0 }
}

convertToIntOrUseDefault("NotANumber")
