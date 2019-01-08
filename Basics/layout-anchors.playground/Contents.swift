// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/layout-anchors
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit
import PlaygroundSupport

// -- Defining our views --

let label = UILabel()
label.translatesAutoresizingMaskIntoConstraints = false
label.text = "I’m a label"
label.backgroundColor = .red

let button = UIButton()
button.translatesAutoresizingMaskIntoConstraints = false
button.setTitle("I’m a button", for: .normal)
button.backgroundColor = .blue

let parent = UIView()
parent.frame.size = CGSize(width: 400, height: 600)
parent.backgroundColor = .white
parent.addSubview(label)
parent.addSubview(button)

PlaygroundPage.current.liveView = parent

// -- Manually defining a constraint --

let constraint = NSLayoutConstraint(
    item: label,
    attribute: .height,
    relatedBy: .equal,
    toItem: button,
    attribute: .height,
    multiplier: 1,
    constant: 0
)

// -- Activating a single constraint --

constraint.isActive = true

// -- Using layout anchors and the NSLayoutConstraint.activate API --

NSLayoutConstraint.activate([
    // Place the button at the center of its parent
    button.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
    button.centerYAnchor.constraint(equalTo: parent.centerYAnchor),

    // Give the label a minimum width based on the button’s width
    label.widthAnchor.constraint(greaterThanOrEqualTo: button.widthAnchor),

    // Place the label 20 points beneath the button
    label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
    label.centerXAnchor.constraint(equalTo: button.centerXAnchor)
])
