// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/animations
// (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit
import PlaygroundSupport

// --- Setting up a view controller to display things in ---

let viewController = UIViewController()
PlaygroundPage.current.liveView = viewController

// --- Creating a button to animate ---

let buttonA = UIButton()
buttonA.backgroundColor = .green
buttonA.setTitle("I'm a button!", for: .normal)
buttonA.sizeToFit()
viewController.view.addSubview(buttonA)

// --- Animating using UIView.animate ---

// Note: The animation duration is longer here than in the article,
// to make it easier to see the animation in the live view.
UIView.animate(withDuration: 3,
               delay: 0.5,
               options: .curveEaseInOut,
               animations: {
                buttonA.center.x += 100
                buttonA.frame.size.width = 200
}, completion: { _ in
    buttonA.backgroundColor = .red
})

// --- Creating a second button to animate ---

let buttonB = UIButton()
buttonB.backgroundColor = .green
buttonB.setTitle("I'm a second button!", for: .normal)
buttonB.sizeToFit()
buttonB.frame.origin.y = 200
viewController.view.addSubview(buttonB)

// --- Animating using a property animator ---

let animator = UIViewPropertyAnimator(
    duration: 3,
    curve: .easeInOut) {
        buttonB.center.x += 100
        buttonB.frame.size.width = 200
}

let viewHasAdditionalContent = true

if viewHasAdditionalContent {
    animator.addAnimations {
        buttonB.center.y += 100
    }
}

animator.startAnimation()

// --- Pausing and starting an animation again ---

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    animator.pauseAnimation()

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        animator.startAnimation()
    }
}



