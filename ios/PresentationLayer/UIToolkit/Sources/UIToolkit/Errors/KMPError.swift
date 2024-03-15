//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SharedDomain
import KMPSharedDomain

extension SharedDomain.KMPError: LocalizedError {
    public var errorDescription: String? {
        switch kmpError {
        case is AuthError.EmptyField: L10n.register_view_fill_all_fields
        case is AuthError.PasswordsDontMatch: L10n.register_view_passwords_dont_match
        default: kmpError.message
        }
    }
}
