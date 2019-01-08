// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/child-view-controllers
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit
import PlaygroundSupport

let parent = UIViewController()
let child = UIViewController()

// --- Adding a child view controller ---

// First, add the view of the child to the view of the parent
parent.view.addSubview(child.view)

// Then, add the child to the parent
parent.addChild(child)

// Finally, notify the child that it was moved to a parent
child.didMove(toParent: parent)

// --- Removing a child view controller ---

// First, notify the child that it’s about to be removed
child.willMove(toParent: nil)

// Then, remove the child from its parent
child.removeFromParent()

// Finally, remove the child’s view from the parent’s
child.view.removeFromSuperview()

// --- Defining a convenience extension ---

extension UIViewController {
    func add(_ child: UIViewController) {
        view.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

// --- An example child view controller ---

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        // Center our spinner both horizontally & vertically
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// --- Using the above VC in a content VC ---

class ContentViewController: UIViewController {
    private let loader = ContentLoader()

    func loadContent() {
        let loadingVC = LoadingViewController()
        add(loadingVC)

        loader.load { [weak self] content in
            loadingVC.remove()
            self?.render(content)
        }
    }
}

// --- Testing the above ContentViewController ---

let vc = ContentViewController()
vc.view.backgroundColor = .white
vc.loadContent()
PlaygroundPage.current.liveView = vc

// --- Accessories for demo purposes ---

private class ContentLoader {
    struct Content {}

    func load(then handler: @escaping (Content) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            handler(Content())
        }
    }
}

private extension ContentViewController {
    func render(_ content: ContentLoader.Content) {
        // ...
    }
}
