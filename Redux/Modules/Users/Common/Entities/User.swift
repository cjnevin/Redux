import Foundation

struct User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName
    }
    
    let id: Int
    let firstName: String
    let lastName: String
}
