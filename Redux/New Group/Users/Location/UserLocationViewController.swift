import UIKit
import CoreLocation
import MapKit
import ReSwift
import RxSwift

class UserLocationViewController: UIViewController, TitlableView, AlertableView, ClosableView {
    private lazy var mapView: MKMapView = MKMapView()
    private let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.userLocationState
            }.skipRepeats()
        }
        store.dispatch(RoutingAction(destination: UserLocationRoutingDestination()))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        store.dispatch(FetchUserLocationAction())
        layout()
        setCloseAction {
            store.dispatch(RoutingAction(destination: ExitUserLocationRoutingDestination()))
        }
    }
    
    private func layout() {
        view.backgroundColor = .white
        layoutMapView()
    }
    
    func setUserLocation(_ userLocation: UserLocation) {
        mapView.setUserLocation(userLocation)
    }
}

extension UserLocationViewController: StoreSubscriber {
    func newState(state: UserLocationState) {
        if let user = state.user {
            setTitle("\(user.firstName)'s Location")
        } else {
            setTitle("Unknown User's Location")
        }

        if let location = state.location {
            setUserLocation(location)
        } else {
            if !state.loading {
                let okAction: (String) -> () = { title in
                    return self.dismissAlert()
                        .subscribe()
                        .disposed(by: self.disposeBag)
                }
                let okOption = Alert.Option(title: "OK", style: .cancel, action: okAction)
                
                let name = state.user?.firstName ?? "unknown"
                let alert = Alert(title: "No Location", message: "Location for \(name) is unavailable.", style: .alert, options: [okOption])
                
                presentAlert(alert).subscribe().disposed(by: disposeBag)
            }
        }

        setCloseTitle("Close")
    }
}

private extension UserLocationViewController {
    private func layoutMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension MKMapView {
    func setUserLocation(_ userLocation: UserLocation) {
        removeAnnotations(annotations.filter {
            $0 is MKPlacemark
        })
        
        CLGeocoder().reverseGeocodeLocation(userLocation.location) { [weak self] placemark, error in
            guard let `self` = self else { return }
            if let placemark = placemark?.first {
                self.addAnnotation(MKPlacemark(placemark: placemark))
            }
        }
        centerCoordinate = userLocation.coordinate
    }
}
