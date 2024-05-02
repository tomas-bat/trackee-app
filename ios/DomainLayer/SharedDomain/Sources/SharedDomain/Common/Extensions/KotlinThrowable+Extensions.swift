//
//  Created by Tomáš Batěk on 02.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain

public extension KotlinThrowable {
    var asError: KMPError {
        KMPError(
            ErrorResult(
                message: self.message,
                throwable: self
            )
        )
    }
}
