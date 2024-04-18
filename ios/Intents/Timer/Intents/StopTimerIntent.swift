//
//  Created by Tomáš Batěk on 18.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import AppIntents
@preconcurrency import Factory
import Foundation
import KMPSharedDomain

struct StopTimerIntent: AppIntent {
    
    // MARK: - Dependencies
    
    @Injected(\.stopTimerUseCase) private var stopTimerUseCase
    
    // MARK: - Required
    
    static var title = LocalizedStringResource("stop_timer_intent_title")
    
    static var description = IntentDescription("stop_timer_intent_description")
    
    // MARK: - Parameters
    
    // MARK: - Perform
    
    func perform() async throws -> some IntentResult {
        try await stopTimerUseCase.execute()
        return .result()
    }
}
