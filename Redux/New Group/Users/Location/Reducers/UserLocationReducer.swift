import ReSwift

func userLocationReducer(action: Action, state: UserLocationState?) -> UserLocationState {
    var state = state ?? UserLocationState(user: nil, location: nil, loading: true)
    
    switch action {
    case let setUser as SetUserAction:
        state.user = setUser.user
        
    case let setUserLocation as SetUserLocationAction:
        state.user = setUserLocation.user
        state.location = setUserLocation.location
        state.loading = false
        
    default: break
    }
    
    return state
}
