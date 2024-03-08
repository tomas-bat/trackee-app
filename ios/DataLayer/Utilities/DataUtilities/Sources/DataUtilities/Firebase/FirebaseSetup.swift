//
//  Created by Tomáš Batěk on 08.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Firebase
import Utilities

public struct FirebaseSetup {
    public static func setup() {
        if FirebaseApp.app() == nil {
            // Enable Firebase Analytics debug mode for non production environments
            // Idea taken from: https://stackoverflow.com/a/47594030/6947225
            if Environment.type != .production {
                var args = ProcessInfo.processInfo.arguments
                args.append("-FIRAnalyticsDebugEnabled")
                ProcessInfo.processInfo.setValue(args, forKey: "arguments")
            }
            
            FirebaseApp.configure()
            FirebaseConfiguration.shared.setLoggerLevel(.min)
        }
    }
}
