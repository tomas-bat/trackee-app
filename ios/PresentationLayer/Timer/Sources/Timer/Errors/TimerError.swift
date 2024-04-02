//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SharedDomain
import UIToolkit

extension TimerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .projectNotSelected: L10n.timer_view_project_not_selected
        }
    }
}
