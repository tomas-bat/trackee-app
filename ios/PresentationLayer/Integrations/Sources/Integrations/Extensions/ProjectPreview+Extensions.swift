//
//  Created by Tomáš Batěk on 11.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

extension ProjectPreview {
    var asIdentifiableProject: IdentifiableProject {
        IdentifiableProject(
            projectId: id,
            clientId: client.id
        )
    }
}
