//
//  Created by Tomáš Batěk on 20.10.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain

public extension Error {
    var kmpErrorResult: ErrorResult? {
        (self as? KMPError)?.kmpError
    }
}
