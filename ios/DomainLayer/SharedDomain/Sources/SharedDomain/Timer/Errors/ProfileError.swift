//
//  Created by Tomáš Batěk on 03.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation

public enum ProfileError {
    case validation(Validation)
    
    public enum Validation {
        case nameTooShort
        case missingClient
    }
}
