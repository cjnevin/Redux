import ReSwift

let usersMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            switch action {
            case is FetchUsersAction:
                DispatchQueue.global(qos: .background).async {
                    let users = usersDataStore.users.map { $0.asUser() }
                    DispatchQueue.main.async {
                        store.dispatch(SetUsersAction(users: users))
                    }
                }
            
            case let selectUser as SelectUserAction:
                DispatchQueue.global(qos: .background).async {
                    usersDataStore.selectUser(at: selectUser.userIndex)
                    guard let user = usersDataStore.currentUser?.asUser() else {
                        return
                    }
                    DispatchQueue.main.async {
                        store.dispatch(SetUserAction(user: user))
                    }
                }
            
            case let fetchUserLocation as FetchUserLocationAction:
                DispatchQueue.global(qos: .background).async {
                    guard let user = usersDataStore.currentUser?.asUser() else {
                        return
                    }
                    let location = userLocationDataStore.userLocation(with: user.id)?.asUserLocation()
                    DispatchQueue.main.async {
                        store.dispatch(SetUserLocationAction(user: user, location: location))
                    }
                }
                
            default:
                break
            }
            
            return next(action)
        }
    }
}

