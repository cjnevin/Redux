import ReSwift

func userDetailsReducer(action: Action, state: UserDetailsState?) -> UserDetailsState {
    var state = state ?? UserDetailsState(user: nil, loading: true)
    
    switch action {
    case _ as SelectUserAction:
        state.user = nil
        state.loading = true
        
    case let setUserAction as SetUserAction:
        state.user = setUserAction.user
        state.loading = false
        
    default: break
    }
    
    return state
}
