import Foundation
import ReSwift

enum RoutingMode {
    case push(String, String)
    case pop
    case presentModal(String, String)
    case dismissModal
}

protocol RoutingDestination {
    var mode: RoutingMode { get }
}

struct UsersRoutingDestination: RoutingDestination {
    let mode: RoutingMode = .push("Users", "UsersViewController")
}

struct UserDetailsRoutingDestination: RoutingDestination {
    let mode: RoutingMode = .push("Users", "UserViewController")
}

struct UserLocationRoutingDestination: RoutingDestination {
    let mode: RoutingMode = .presentModal("Users", "UserLocationViewController")
}

struct ExitUserLocationRoutingDestination: RoutingDestination {
    let mode: RoutingMode = .dismissModal
}

final class AppRouter {
    let navigationController: UINavigationController
    var modalViewController: UIViewController?

    init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }

    private func instantiateViewController(identifier: String, storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    fileprivate func present(routingDestination: RoutingDestination) {
        switch routingDestination.mode {
        case .dismissModal:
            dismissViewController(animated: true)
        case .presentModal(let storyboardName, let identifier):
            let viewController = instantiateViewController(identifier: identifier, storyboardName: storyboardName)
            let navigationController = UINavigationController(rootViewController: viewController)
            presentViewController(viewController: navigationController, animated: true)
        case .push(let storyboardName, let identifier):
            let viewController = instantiateViewController(identifier: identifier, storyboardName: storyboardName)
            let shouldAnimate = navigationController.topViewController != nil
            pushViewController(viewController: viewController, animated: shouldAnimate)
        case .pop:
            popViewController(animated: true)
        }

    }

    private func pushViewController(viewController: UIViewController, animated: Bool) {
        let newViewControllerType = type(of: viewController)
        if let currentVc = navigationController.topViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == newViewControllerType {
                return
            }
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    fileprivate func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    fileprivate func presentViewController(viewController: UIViewController, animated: Bool) {
        let newViewControllerType = type(of: viewController)
        if let currentVc = navigationController.presentedViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == newViewControllerType {
                return
            }
        }

        if let currentVc = modalViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == newViewControllerType {
                return
            }
        }

        modalViewController = viewController
        navigationController.present(viewController, animated: true)
    }

    fileprivate func dismissViewController(animated: Bool) {
        navigationController.dismiss(animated: animated, completion: {
            self.modalViewController = nil
        })
    }
}

// MARK: - StoreSubscriber
extension AppRouter: StoreSubscriber {
    func newState(state: RoutingState) {
        present(routingDestination: state.navigationState)
    }
}
