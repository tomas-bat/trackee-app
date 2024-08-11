//
//  Created by Tomáš Batěk on 17.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

extension ProjectColor: Identifiable {
    public var id: String {
        self.rawValue
    }
}
