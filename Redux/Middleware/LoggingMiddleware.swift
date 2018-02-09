import ReSwift

let loggingMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            if let routingAction = action as? RoutingAction {
                print("Routing to \(routingAction.destination)")
            } else {
                print("Interacted with \(action)")
            }
            return next(action)
        }
    }
}
