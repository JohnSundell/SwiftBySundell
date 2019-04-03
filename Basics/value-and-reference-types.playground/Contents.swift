// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/value-and-reference-types
// (c) 2019 John Sundell
// Licensed under the MIT license

import Foundation

/**
 *  Note: In order to differenciate between various implementations, this
 *  sample code adds some suffixes not present in the article - such as
 *  calling the struct implementation 'PostValue', rather than just 'Post'.
 */

// --- Defining Post as a reference type, using a class ---

class Post {
    var title: String
    var text: String
    var numberOfLikes = 0

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}

// --- Mutating a post instance inside of a function ---

func like(_ post: Post) {
    post.numberOfLikes += 1
    showLikeConfirmation()
}

// --- Changes made inside of a function are also reflected outside of it ---

let postA = Post(title: "Hello, world!", text: "...")
like(postA)
print(postA.numberOfLikes) // 1

// --- Defining Post as a value type instead ---

struct PostValue {
    var title: String
    var text: String
    var numberOfLikes = 0

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}

// --- We're now required to copy a value in order to mutate it ---

func like(_ post: PostValue) {
    // Simply re-assigning the post to a new, mutable, variable
    // will actually create a new copy of it.
    var post = post
    post.numberOfLikes += 1
    showLikeConfirmation()
}

// --- Changes made inside of a function are no longer reflected outside of it ---

let postB = PostValue(title: "Hello, world!", text: "...")
like(postB)
print(postB.numberOfLikes) // 0

// --- Using 'inout' lets us pass a value as a reference ---

func like(_ post: inout PostValue) {
    post.numberOfLikes += 1
    showLikeConfirmation()
}

// --- Passing a post value as a reference using the '&' prefix ---

var postC = PostValue(title: "Hello, world!", text: "...")
like(&postC)
print(postC.numberOfLikes) // 1

// --- Making our function return a new value instead ---

func likeAndReturn(_ post: PostValue) -> PostValue {
    var post = post
    post.numberOfLikes += 1
    showLikeConfirmation()
    return post
}

// --- Assigning the updated value back to our original variable ---

var postD = PostValue(title: "Hello, world!", text: "...")
postD = likeAndReturn(postD)
print(postD.numberOfLikes) // 1

// --- Adding convenience APIs to our post type to enable easier mutations ---

extension PostValue {
    mutating func like() {
        numberOfLikes += 1
    }
}

extension PostValue {
    func liked() -> PostValue {
        var post = self
        post.like()
        return post
    }
}

// --- Simplifying our 'like' function from before ---

func likeAndReturnSimplified(_ post: PostValue) -> PostValue {
    showLikeConfirmation()
    return post.liked()
}
