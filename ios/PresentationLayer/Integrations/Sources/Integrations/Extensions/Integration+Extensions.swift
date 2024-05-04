//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import SwiftUI
import UIToolkit

extension Integration {
    var image: Image {
        switch onEnum(of: self) {
        case .clockify: Asset.Images.clockifyLogo.image
        case .csv: Image(systemSymbol: .tablecellsFill)
        }
    }
    
    var type: IntegrationType {
        switch onEnum(of: self) {
        case .csv: .csv
        case .clockify: .clockify
        }
    }
}
