//
//  Created by Tomáš Batěk on 18.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import AppIntents
@preconcurrency import Factory
import Foundation
import KMPSharedDomain

struct CancelTimerIntent: AppIntent {
    
    // MARK: - Dependencies
    
    @Injected(\.cancelTimerUseCase) private var cancelTimerUseCase
    
    // MARK: - Required
    
    static var title = LocalizedStringResource("cancel_timer_intent_title")
    
    static var description = IntentDescription("cancel_timer_intent_description")
    
    // MARK: - Parameters
    
    // MARK: - Perform
    
    func perform() async throws -> some IntentResult {
        try await cancelTimerUseCase.execute()
        return .result()
    }
}
