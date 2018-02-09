import Foundation
import CoreLocation

struct UserLocation: Equatable {
    static func ==(lhs: UserLocation, rhs: UserLocation) -> Bool {
        return lhs.userId == rhs.userId &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
    
    let userId: Int
    let latitude: Double
    let longitude: Double
    
    var location: CLLocation {
        return CLLocation(latitude: latitude,
                          longitude: longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
}
