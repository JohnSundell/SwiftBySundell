// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/memory-management
// Copyright (c) 2019 John Sundell
// Licensed under the MIT license

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        retainCountForCreatedObjects()
        referenceRetainCycle()
        breakingRetainCycleWithWeakReference()
        closureRetainCycle()
        breakingClosureRetainCycleWithWeakCapture()
        return true
    }
}
