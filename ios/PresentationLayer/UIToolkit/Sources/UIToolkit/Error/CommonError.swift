//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SharedDomain

extension CommonError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unknownError(message): message ?? localizedDescription
        default: localizedDescription
        }
    }
}
