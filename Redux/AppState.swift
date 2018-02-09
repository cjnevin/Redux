import ReSwift

struct AppState: StateType {
    let routingState: RoutingState
    let usersState: UsersState
    let userDetailsState: UserDetailsState
    let userLocationState: UserLocationState
}
