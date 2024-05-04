//
//  Created by Tomáš Batěk on 18.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import Utilities

public final class DefaultAppInfoProvider: NSObject {
    
    private weak var delegate: LogoutHandlerDelegate?
    
    override public init() {
        super.init()
    }
}

extension DefaultAppInfoProvider: AppInfoProvider, KMPSharedDomain.AppInfoProvider {
    public var environment: AppEnvironment {
        switch Environment.type {
        case .alpha: .alpha
        case .beta: .beta
        case .production: .production
        }
    }
    
    public var flavor: AppFlavor {
        switch Environment.flavor {
        case .debug: .debug
        case .release: .theRelease
        }
    }
    
    public func setLogoutHandlerDelegate(_ delegate: LogoutHandlerDelegate) {
        self.delegate = delegate
    }
    
    public func __logout() async throws {
        try await delegate?.logout()
    }
}
