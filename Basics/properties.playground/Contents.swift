// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/properties
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit

// --- A Book type containing stored, mutable properties ---

struct Book {
    var name: String
    var author: String
    var numberOfStars = 0
}

// --- Adding a constant 'id' property to our Book type ---

struct Book2 {
    let id: UUID
    var name: String
    var author: String
    var numberOfStars = 0
}

// --- Only mutable properties can be modified after initialization ---

var book = Book2(
    id: UUID(),
    name: "The Swift Programming Language",
    author: "Apple"
)

// book.id = UUID() // Compiler error
book.name = "New name" // Allowed
book.numberOfStars += 1 // Also allowed

// --- Using computed properties ---

extension Book {
    var hasLongName: Bool {
        name.count > 30
    }
}

struct Author {
    var name: String
    var country: String
}

struct Book3 {
    let id: UUID
    var name: String
    var author: Author
    var numberOfStars = 0
}

extension Book3 {
    var authorName: String {
        get { author.name }
        set { author.name = newValue }
    }
}

// --- Using lazy properties ---

class BookViewController: UIViewController {
    private lazy var nameLabel = makeNameLabel()
    private lazy var authorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(nameLabel)
        view.addSubview(authorLabel)
    }

    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .orange
        return label
    }
}

/// --- Defining and using a static property ---

extension Book {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

let date = Date()
let string = Book.dateFormatter.string(from: date)

/// --- Using property observers ---

class RatingViewController: UIViewController {
    var numberOfStars = 0 {
        didSet { starCountLabel.text = String(numberOfStars) }
    }

    private lazy var starCountLabel = UILabel()
}

struct Book4 {
    let id: UUID
    var name: String
    var author: Author
    var numberOfStars = 0 {
        didSet {
            // If the new value was higher than 9999, we reduce
            // it down to that value, which is our maximum:
            numberOfStars = min(9999, numberOfStars)
        }
    }
}

/// --- Using key paths ---

func loadBooks() -> [Book] {
    [Book(name: "Book One", author: "Author One"),
     Book(name: "Book Two", author: "Author Two"),
     Book(name: "Book Three", author: "Author Three")]
}

// Converting an array of books into an array of strings, by
// extracting each book's name:
let books = loadBooks() // [Book]
let bookNames = books.map(\.name) // [String]
