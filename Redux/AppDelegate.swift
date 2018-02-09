import UIKit
import ReSwift
import ReSwiftRouter

var store = Store<AppState>(reducer: appReducer, state: nil, middleware: [loggingMiddleware, usersMiddleware])
let usersDataStore = UserMemoryDataStore()
let userLocationDataStore = UserLocationMemoryDataStore()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appRouter: AppRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        appRouter = AppRouter(window: window)
        
        return true
    }
}


