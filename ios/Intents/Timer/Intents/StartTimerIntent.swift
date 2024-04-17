//
//  Created by Tomáš Batěk on 12.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import AppIntents
@preconcurrency import Factory
import Foundation
import KMPSharedDomain
import UIToolkit

struct StartTimerIntent: AppIntent {
    
    // MARK: - Dependencies
    
    @Injected(\.startTimerUseCase) private var startTimerUseCase
    
    // MARK: - Required
    
    static var title = LocalizedStringResource("start_timer_intent_title")
    
    static var description = IntentDescription("start_timer_intent_description")
    
    // MARK: - Parameters
    
    @Parameter(title: "start_timer_intent_parameter_description")
    var description: String?
    
    @Parameter(title: "start_timer_intent_parameter_project")
    var project: ProjectPreviewEntity?
    
    // MARK: - Perform
    
    func perform() async throws -> some IntentResult {
        let params = StartTimerUseCaseParams(
            body: StartTimerBody(
                clientId: project?.clientId,
                projectId: project?.projectId,
                description: description
            )
        )
        try await startTimerUseCase.execute(params: params)
        return .result()
    }
}
