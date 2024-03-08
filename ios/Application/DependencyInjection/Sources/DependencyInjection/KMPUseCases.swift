//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import KMPSharedDomain
import Factory
import SharedDomain

public extension Container {
    // Koin
    private var kmp: Factory<KMPDependency> { self { KMPKoinDependency() }.singleton }
    
    
}
