//
//  Created by Viktor Kaderabek on 10/08/2018.
//  Copyright © 2018 Matee. All rights reserved.
//

import CoreLocation
import LocationProvider
import SharedDomain

public final class LocationRepositoryImpl: LocationRepository {
    
    private let location: LocationProvider
    
    public init(locationProvider: LocationProvider) {
        location = locationProvider
    }
    
    public func readIsLocationEnabled() -> Bool {
        location.isLocationEnabled()
    }
    
    public func readCurrentLocation(withAccuracy accuracy: CLLocationAccuracy) -> AsyncStream<CLLocation> {
        location.getCurrentLocation(withAccuracy: accuracy)
    }
}
