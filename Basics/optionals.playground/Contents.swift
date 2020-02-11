// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/optionals
// (c) 2020 John Sundell
// Licensed under the MIT license

import UIKit

// --- Using 'if let' and 'guard' to unwrap an optional ---

func setupAppWithIfLet(forUser user: User?) {
    if let user = user {
        showHomeScreen(for: user)
    } else {
        showLoginScreen()
    }
}

func setupAppWithGuard(forUser user: User?) {
    guard let user = user else {
        // Guard statements require us to "exit" out of the
        // current scope, for example by returning:
        return showLoginScreen()
    }

    showHomeScreen(for: user)
}

// --- Implementing an enum with a 'none' case ---

enum RelationshipWithNoneCase {
    case none
    case friend
    case family
    case coworker
}

struct UserWithNoneCase {
    var name: String
    var relationship: RelationshipWithNoneCase = .none
}

// --- Implementing such an enum using an optional instead ---

enum Relationship {
    case friend
    case family
    case coworker
}

struct UserWithOptional {
    var name: String
    var relationship: Relationship? = nil
}

// --- Using lazy properties to implement a view controller's subviews ---

class ProfileViewController: UIViewController {
    private lazy var headerView = HeaderView()
    private lazy var logOutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerView)
        view.addSubview(logOutButton)

        // More view configuration
    }

    func userDidUpdate(_ user: User) {
        headerView.imageView.image = user.image
        headerView.label.text = user.name
    }
}

// --- Switching on an optional ---

func icon(forRelationship relationship: Relationship?) -> Icon? {
    // Here we switch on the optional itself, rather than on
    // its underlying Relationship value:
    switch relationship {
    case .some(let relationship):
        // Then, we switch on the wrapped value itself:
        switch relationship {
        case .friend:
            return .user
        case .family:
            return .familyMember
        case .coworker:
            return .work
        }
    case .none:
        return nil
    }
}

func icon(for relationship: Relationship?) -> Icon? {
    switch relationship {
    case .friend:
        return .user
    case .family:
        return .familyMember
    case .coworker:
        return .work
    case nil:
        return nil
    }
}

// --- Using 'map' to transform an optional ---

func makeRequest(forURLString string: String) -> URLRequest? {
    URL(string: string).map { URLRequest(url: $0) }
}

// --- Extending the Optional type ---

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        // If the left-hand expression is nil, the right one
        // will be used, meaning that 'true' is our default:
        self?.isEmpty ?? true
    }

    var nonEmpty: Wrapped? {
        // Either return this collection, or nil if it's empty:
        isNilOrEmpty ? nil : self
    }
}

extension EditorViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text.nonEmpty else {
            return
        }

        // Handle non-empty text
        print(text)
    }
}
