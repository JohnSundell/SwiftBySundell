// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/optionals
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit

// Accessories for demo purposes

public struct User {
    public var name: String
    public var image: UIImage
}

public func showHomeScreen(for user: User) {}

public func showLoginScreen() {}

public class HeaderView: UIView {
    public let imageView = UIImageView()
    public let label = UILabel()
}

public enum Icon {
    case user
    case familyMember
    case work
}

public class EditorViewController: UIViewController {}
