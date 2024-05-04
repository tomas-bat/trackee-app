//
//  Created by Tomáš Batěk on 18.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation

public protocol LogoutHandlerDelegate: AnyObject {
    func logout() async throws
}

public protocol AppInfoProvider {
    func setLogoutHandlerDelegate(_ delegate: LogoutHandlerDelegate)
}
