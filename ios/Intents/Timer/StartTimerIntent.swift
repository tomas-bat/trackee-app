//
//  Created by Tomáš Batěk on 12.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import AppIntents
@preconcurrency import Factory
import Foundation
import UIToolkit

struct StartTimerIntent: AppIntent {
    
    @Injected(\.startTimerUseCase) private var startTimerUseCase
    
    static var title = LocalizedStringResource("start_timer_intent_title")
    
    static var description = IntentDescription("start_timer_intent_description")
    
    func perform() async throws -> some IntentResult {
        try await startTimerUseCase.execute()
        return .result()
    }
}
