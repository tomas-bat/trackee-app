//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import SwiftUI

public extension ProjectType {
    var image: Image {
        switch self {
        case .school: Image(systemSymbol: .graduationcap)
        case .work: Image(systemSymbol: .briefcase)
        }
    }
    
    var imageSystemName: String {
        switch self {
        case .school: "graduationcap"
        case .work: "briefcase"
        }
    }
}
