//
//  Created by Petr Chmelar on 17.02.2021.
//  Copyright © 2021 Matee. All rights reserved.
//

import SharedDomain

struct NETRegistrationData: Encodable {
    let email: String
    let pass: String
    let firstName: String
    let lastName: String
}

// Conversion from DomainModel to NetworkModel
extension RegistrationData {
    var networkModel: NETRegistrationData {
        NETRegistrationData(
            email: email,
            pass: password,
            firstName: firstName,
            lastName: lastName
        )
    }
}
