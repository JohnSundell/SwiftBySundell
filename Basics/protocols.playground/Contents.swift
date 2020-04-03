// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/protocols
// (c) 2020 John Sundell
// Licensed under the MIT license

import Foundation
import AVFoundation

// --- Declaring and conforming to a protocol ---

protocol Playable {
    var audioURL: URL { get }
}

struct Song: Playable {
    var name: String
    var album: Album
    var audioURL: URL
    var isLiked: Bool
}

struct Album {
    var name: String
    var imageURL: URL
    var audioURL: URL
    var isLiked: Bool
}

extension Album: Playable {}

// --- A Player class which currently uses duplicate methods ---

class Player {
    private let avPlayer = AVPlayer()

    func play(_ song: Song) {
        let item = AVPlayerItem(url: song.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }

    func play(_ album: Album) {
        let item = AVPlayerItem(url: album.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }
}

// --- Simplifying the above Player using our Playable protocol ---

class Player2 {
    private let avPlayer = AVPlayer()

    func play(_ resource: Playable) {
        let item = AVPlayerItem(url: resource.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }
}

// --- Improving our protocol's naming ---

// Renaming our declaration:
protocol AudioURLConvertible {
    var audioURL: URL { get }
}

// Conforming to the new version:
extension Song: AudioURLConvertible {}
extension Album: AudioURLConvertible {}

// And updating our Player implementation:
class Player3 {
    private let avPlayer = AVPlayer()

    func play(_ resource: AudioURLConvertible) {
        let item = AVPlayerItem(url: resource.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }
}

// --- A protocol with a mutating method requirement ---

protocol Likeable {
    mutating func markAsLiked()
}

extension Song: Likeable {
    mutating func markAsLiked() {
        isLiked = true
    }
}

// --- Using a property requirement instead ---

protocol LikeableWithProperty {
    var isLiked: Bool { get set }
}

extension Song: LikeableWithProperty {}
extension Album: LikeableWithProperty {}

// --- Implementing a protocol extension ---

extension LikeableWithProperty {
    mutating func markAsLiked() {
        isLiked = true
    }
}

// --- Creating a protocol-based abstraction ---

protocol PlayerProtocol {
    func play(_ resource: AudioURLConvertible)
}

// --- Multiple implementations of the above protocol ---

class EnqueueingPlayer: PlayerProtocol {
    private let avPlayer = AVQueuePlayer()

    func play(_ resource: AudioURLConvertible) {
        let item = AVPlayerItem(url: resource.audioURL)
        avPlayer.insert(item, after: nil)
        avPlayer.play()
    }
}

extension Player3: PlayerProtocol {}

func makePlayer() -> PlayerProtocol {
    if Settings.useEnqueueingPlayer {
        return EnqueueingPlayer()
    } else {
        return Player3()
    }
}

// --- Extending the standard library's Collection protocol ---

extension Collection where Element: Numeric {
    func sum() -> Element {
        // The reduce method is implemented using a protocol extension
        // within the standard library, which in turn enables us
        // to use it within our own extensions as well:
        reduce(0, +)
    }
}

let numbers = [1, 2, 3, 4]
numbers.sum() // 10
