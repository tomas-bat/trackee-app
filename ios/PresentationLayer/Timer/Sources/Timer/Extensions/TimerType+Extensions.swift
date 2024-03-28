//
//  Created by Tomáš Batěk on 28.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

extension TimerType {
    var switched: TimerType {
        switch self {
        case .timer: .manual
        case .manual: .timer
        }
    }
}
