//
//  Created by Petr Chmelar on 06/02/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import Foundation
import OSLog
import Utilities

@MainActor
open class BaseViewModel {
    
    /// All tasks that are currently executed
    public private(set) var tasks: [Task<Void, Never>] = []
    
    public init() {
        Logger.lifecycle.info("\(type(of: self)) initialized")
    }
    
    deinit {
        Logger.lifecycle.info("\(type(of: self)) deinitialized")
    }
    
    /// Override this method in a subclass for custom behavior when a view appears
    open func onAppear() {}
    
    /// Override this method in a subclass for custom behavior when a view disappears
    open func onDisappear() {
        // Cancel all tasks when we are going away
        tasks.forEach { $0.cancel() }
    }
    
    @discardableResult
    public func executeTask(_ task: Task<Void, Never>) -> Task<Void, Never> {
        tasks.append(task)
        Task {
            await task.value
            
            // Remove task when done
            objc_sync_enter(tasks)
            tasks = tasks.filter { $0 != task }
            objc_sync_exit(tasks)
        }
        return task
    }
    
    public func awaitAllTasks() async {
        for task in tasks { await task.value }
    }
    
    public func execute(
        _ block: () async throws -> Void,
        onCancel: (CancellationError) async -> Void = { _ in },
        onError: (Error) async -> Void = { _ in }
    ) async {
        do {
            try await block()
        } catch let cancellationError as CancellationError {
            await onCancel(cancellationError)
        } catch {
            await onError(error)
        }
    }
}
