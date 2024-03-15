//
//  Created by Petr Chmelar on 26.03.2021
//  Copyright © 2021 Matee. All rights reserved.
//

import CoreLocation
import DependencyInjection
import Factory
@testable import Profile
@testable import SharedDomain
import UIToolkit
import XCTest

@MainActor
final class ProfileViewModelTests: XCTestCase {

    // MARK: Dependencies
    
    private let fc = FlowControllerMock<ProfileFlow>(navigationController: UINavigationController())
    

    
    private func createViewModel() -> ProfileViewModel {
        Container.shared.reset()

        
        return ProfileViewModel(flowController: fc)
    }

    // MARK: Tests

}
