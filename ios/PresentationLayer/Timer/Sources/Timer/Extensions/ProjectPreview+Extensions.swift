//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

extension ProjectPreview {
    var rawProject: Project {
        Project(
            id: id,
            clientId: client.id,
            type: type,
            name: name,
            color: color
        )
    }
}
