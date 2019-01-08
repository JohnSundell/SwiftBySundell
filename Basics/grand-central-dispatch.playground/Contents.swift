// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/grand-central-dispatch
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit

// --- Executing an asynchronous closure ---

var items: [Item]?

DispatchQueue.main.async {
    items = findItems(matching: "News")
    print("Asynchronous items:", items as Any)
}

print("Synchronous items:", items as Any)

// --- Performing work on a background queue ---

DispatchQueue.global(qos: .background).async {
    let files = loadFiles()
    process(files)
}

// --- Performing UI updates on the main queue ---

let label = UILabel()

// Since we’re loading content for the UI here, we use a
// higher priority quality of service for this operation.
DispatchQueue.global(qos: .userInitiated).async {
    let text = loadArticleText()

    // Perform all UI updates on the main queue
    DispatchQueue.main.async {
        label.text = text
    }
}

// --- Creating dispatch queues ---

// This queue will have the default quality of service and be
// serial — meaning that any previous work has to be completed
// before any new work will begin.
let queue = DispatchQueue(label: "CacheQueue")

// This queue has a higher priority — due to it being marked
// as ‘userInitiated’, and is concurrent — meaning that multiple
// pieces of work can be executed simultaneously.
let queue2 = DispatchQueue(
    label: "ConcurrentQueue",
    qos: .userInitiated,
    attributes: [.concurrent]
)
