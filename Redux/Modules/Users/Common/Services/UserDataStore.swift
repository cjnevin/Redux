import Foundation

protocol UserDataStoreHaving {
    var userDataStore: UserDataStore { get }
}

protocol UserDataStore {
    var users: [UserDTO] { get }
    var currentUser: UserDTO? { get }
    func selectUser(at index: Int)
}

class UserMemoryDataStore: UserDataStore {
    let users: [UserDTO] = {
        return [
            UserDTO(id: 1, firstName: "Kate", lastName: "Winslet"),
            UserDTO(id: 2, firstName: "Hugh", lastName: "Jackman"),
            UserDTO(id: 3, firstName: "Nicole", lastName: "Kidman"),
            UserDTO(id: 4, firstName: "David", lastName: "Attenborough"),
            UserDTO(id: 5, firstName: "Johnny", lastName: "Depp"),
            UserDTO(id: 6, firstName: "Jim", lastName: "Carrey")
        ]
    }()

    private(set) var currentUser: UserDTO?

    func selectUser(at index: Int) {
        currentUser = user(at: index)
    }

    private func user(at index: Int) -> UserDTO {
        return users[index]
    }
}
