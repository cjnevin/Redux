import UIKit
import ReSwift

class UsersViewController: UITableViewController, TitlableView {
    private let dataSource = UsersTableViewDataSource()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.usersState
            }
        }
        store.dispatch(RoutingAction(destination: UsersRoutingDestination()))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        dataSource.tableView = tableView
        store.dispatch(FetchUsersAction())
        setTitle("Users")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SelectUserAction(userIndex: indexPath.row))
        store.dispatch(RoutingAction(destination: UserDetailsRoutingDestination()))
    }
}

extension UsersViewController: StoreSubscriber {
    func newState(state: UsersState) {
        dataSource.users = state.users
    }
}
