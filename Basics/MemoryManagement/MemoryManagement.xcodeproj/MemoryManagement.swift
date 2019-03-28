// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/memory-management
// Copyright (c) 2019 John Sundell
// Licensed under the MIT license

/**
 *  Note: The following sample code uses CFGetRetainCount to
 *  measure the retain count of various objects. While this
 *  is a good tool to use to understand ARC, it should never
 *  be used to make decisions in actual production code, since
 *  various ARC implementation details can influence the actual
 *  retain count.
 *
 *  Also, always run this app in RELEASE mode, since in DEBUG
 *  retain counts behave a bit differently to enable inspection
 *  of variables and other debugging features.
 */

import Foundation

// --- Defining our types ---

class Ship {
    var cargo: Cargo?
    var unloadObservation: (() -> Void)?
}

class Cargo {
    var ship: Ship?
}

// --- Measuring the retain count for created objects ---

func retainCountForCreatedObjects() {
    let ship = Ship()
    ship.cargo = Cargo()

    print("RETAIN COUNT FOR CREATED OBJECTS")
    print("Retain count for ship:", CFGetRetainCount(ship))
    print("Retain count for cargo:", CFGetRetainCount(ship.cargo))
    print("----------")
}

// --- Causing a retain cycle with two mutual strong references ---

func referenceRetainCycle() {
    let ship = Ship()
    let cargo = Cargo()

    // Now, neither our ship or cargo will ever be deallocated,
    // since their retain counts will never reach zero.
    ship.cargo = cargo
    cargo.ship = ship

    // Both objects' retain count will now be 2, since they are being retained
    // both locally and by each other.
    print("REFERENCE RETAIN CYCLE")
    print("Retain count for ship:", CFGetRetainCount(ship))
    print("Retain count for cargo:", CFGetRetainCount(ship.cargo))

    // Once we break the cycle, ship's retain count will go back to 1.
    print("BREAKING THE CYCLE")
    cargo.ship = nil
    print("Retain count for ship:", CFGetRetainCount(ship))
    print("Retain count for cargo:", CFGetRetainCount(ship.cargo))
    print("----------")
}

// --- Breaking the above retain cycle using a weak reference ---

func breakingRetainCycleWithWeakReference() {
    // Here we're overriding our global types with local ones,
    // to demonstrate how weak references can break a retain cycle.
    class Ship {
        var cargo: Cargo?
    }

    class Cargo {
        // We now hold onto the cargo's ship weakly, which won't
        // increment its retain count.
        weak var ship: Ship?
    }

    let ship = Ship()
    let cargo = Cargo()
    ship.cargo = cargo
    cargo.ship = ship

    print("BREAKING THE CYCLE WITH A WEAK REFERENCE")
    print("Retain count for ship:", CFGetRetainCount(ship))
    print("Retain count for cargo:", CFGetRetainCount(ship.cargo))
    print("----------")
}

// --- Causing a retain cycle with closure capturing ---

func closureRetainCycle() {
    let ship = Ship()

    ship.unloadObservation = {
        // Since we're using 'ship' here, it gets captured strongly
        // by the closure, causing a retain cycle, since the closure
        // is in turn owned by the ship itself.
        ship.cargo = loadNextCargo()
    }

    print("CLOSURE RETAIN CYCLE")
    print("Retain count for ship:", CFGetRetainCount(ship))

    print("BREAKING THE CYCLE")
    ship.unloadObservation = nil
    print("Retain count for ship:", CFGetRetainCount(ship))
    print("----------")
}

// --- Breaking the above retain cycle with a weak capture ---

func breakingClosureRetainCycleWithWeakCapture() {
    let ship = Ship()

    ship.unloadObservation = { [weak ship] in
        // Since the ship is now captured weakly, it becomes an
        // optional within the closure's scope.
        ship?.cargo = loadNextCargo()
    }

    print("BREAKING THE CYCLE WITH A WEAK CAPTURE")
    print("Retain count for ship:", CFGetRetainCount(ship))
}

// --- Utility function ---

func loadNextCargo() -> Cargo {
    return Cargo()
}
