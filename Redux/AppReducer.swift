import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        routingState: routingReducer(action: action, state: state?.routingState),
        usersState: userListReducer(action: action, state: state?.usersState),
        userDetailsState: userDetailsReducer(action: action, state: state?.userDetailsState),
        userLocationState: userLocationReducer(action: action, state: state?.userLocationState))
}
