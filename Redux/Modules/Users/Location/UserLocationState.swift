import ReSwift

struct UserLocationState: StateType, Equatable {
    static func ==(lhs: UserLocationState, rhs: UserLocationState) -> Bool {
        return lhs.user == rhs.user &&
            lhs.location == rhs.location &&
            lhs.loading == rhs.loading
    }
    var user: User?
    var location: UserLocation?
    var loading: Bool
}
