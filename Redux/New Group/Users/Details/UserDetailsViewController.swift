import UIKit
import SnapKit
import ReSwift

class UserDetailsViewController: UIViewController, TitlableView {
    private lazy var showLocationButton: UIButton = UIButton.makeButton()
    private lazy var firstNameLabel: UILabel = UILabel.makeFirstNameLabel()
    private lazy var lastNameLabel: UILabel = UILabel.makeLastNameLabel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.userDetailsState
            }
        }
        store.dispatch(RoutingAction(destination: UserDetailsRoutingDestination()))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layout()

        showLocationButton.addTarget(self, action: #selector(showLocation), for: .touchUpInside)
    }

    func layout() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        view.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(firstNameLabel.snp.bottom).inset(20)
            make.height.equalTo(44)
        }
        
        view.addSubview(showLocationButton)
        showLocationButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    @objc private func showLocation() {
        store.dispatch(RoutingAction(destination: UserLocationRoutingDestination()))
    }

    func setShowLocationTitle(_ title: String) {
        showLocationButton.setTitle(title, for: .normal)
    }

    func setFirstName(_ firstName: String) {
        firstNameLabel.text = "First name: \(firstName)"
    }

    func setLastName(_ lastName: String) {
        lastNameLabel.text = "Last name: \(lastName)"
    }
}

extension UserDetailsViewController: StoreSubscriber {
    func newState(state: UserDetailsState) {
        if state.loading {
            setTitle("Loading...")
            return
        }
        guard let user = state.user else {
            return
        }
        setShowLocationTitle("Show Location")
        setFirstName(user.firstName)
        setLastName(user.lastName)
        setTitle("\(user.firstName) \(user.lastName)")
    }
}

private extension UILabel {
    static func makeFirstNameLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.blue
        return label
    }
    
    static func makeLastNameLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.orange
        return label
    }
}

private extension UIButton {
    static func makeButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }
}
