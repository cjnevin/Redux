import ReSwift

struct RoutingState: StateType {
    var navigationState: RoutingDestination

    init(navigationState: RoutingDestination = UsersRoutingDestination()) {
        self.navigationState = navigationState
    }
}
