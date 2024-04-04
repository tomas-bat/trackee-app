//
//  Created by Tomáš Batěk on 03.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SharedDomain
import UIToolkit

extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .validation(reason):
            switch reason {
            case .nameTooShort: L10n.client_detail_name_too_short
            }
        }
    }
}
