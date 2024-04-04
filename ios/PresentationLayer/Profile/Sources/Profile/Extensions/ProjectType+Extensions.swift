//
//  Created by Tomáš Batěk on 04.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

extension ProjectType: Identifiable {
    public var id: String {
        self.rawValue
    }
}
