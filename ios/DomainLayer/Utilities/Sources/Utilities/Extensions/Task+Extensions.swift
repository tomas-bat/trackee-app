//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation

@MainActor
public extension Task where Failure == Error {
    @discardableResult
    static func delayed(
        byTimeInterval delayInterval: TimeInterval,
        priority: TaskPriority? = nil,
        operation: @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            let delay = UInt64(delayInterval * 1_000_000_000)
            try await Task<Never, Never>.sleep(nanoseconds: delay)
            return try await operation()
        }
    }
    
    // Start a new Task with a timeout. If the timeout expires before the operation is
    // completed then the task is cancelled and an error is thrown.
    init(priority: TaskPriority? = nil, timeout: TimeInterval, operation: @escaping @Sendable () async throws -> Success) {
        self = Task(priority: priority) {
            try await withThrowingTaskGroup(of: Success.self) { group -> Success in
                group.addTask(operation: operation)
                group.addTask {
                    try await _Concurrency.Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                    throw TimeoutError()
                }
                guard let success = try await group.next() else {
                    throw _Concurrency.CancellationError()
                }
                group.cancelAll()
                return success
            }
        }
    }
}

public extension Task where Failure == Error {
    struct TimeoutError: LocalizedError {
        public var errorDescription: String? = "Task timed out before completion"
    }
}
