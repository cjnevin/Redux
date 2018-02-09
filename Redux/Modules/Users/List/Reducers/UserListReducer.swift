import ReSwift

func userListReducer(action: Action, state: UsersState?) -> UsersState {
    var state = state ?? UsersState(users: [])
    
    switch action {
    case let setUsersAction as SetUsersAction:
        state.users = setUsersAction.users
        
    default: break
    }
    
    return state
}
