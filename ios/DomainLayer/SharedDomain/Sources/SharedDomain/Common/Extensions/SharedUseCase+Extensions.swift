// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable multiline_arguments

import KMPSharedDomain
import Foundation

private class JobWrapper {
    var job: Kotlinx_coroutines_coreJob?
    
    func setJob(_ job: Kotlinx_coroutines_coreJob?) {
        self.job = job
    }
}

public extension UseCaseFlowNoParams {
    func execute<Out>() -> AsyncStream<Out> {
        let _: JobWrapper = JobWrapper()
        return AsyncStream<Out> { continuation in
            let coroutineJob = SwiftCoroutinesKt.subscribe(self) { data in
                let value: Out = data as! Out
                continuation.yield(value)
            } onComplete: {
                continuation.finish()
            } onThrow: { _ in
                continuation.finish()
            }
            continuation.onTermination = { _ in
                coroutineJob.cancel(cause: nil)
            }
        }
    }
}

public extension UseCaseFlowResult {
    func execute<In: Any, Out>(params: In) -> AsyncStream<Out> {
        let _: JobWrapper = JobWrapper()
        return AsyncStream<Out> { continuation in
            let coroutineJob = SwiftCoroutinesKt.subscribe(self, params: params) { result in
                continuation.yield(result as! Out)
            } onComplete: {
                continuation.finish()
            } onThrow: { _ in
                continuation.finish()
            }
            continuation.onTermination = { _ in
                coroutineJob.cancel(cause: nil)
            }
        }
    }
}

public extension UseCaseResult {
    func execute<In: Any, Out>(params: In) async throws -> Out {
        let result = try await invoke(params: params)
        switch onEnum(of: result) {
        case let .success(success): return success.data as! Out
        case let .error(error): throw error.error.asError
        }
    }
    
    func execute<In: Any>(params: In) async throws {
        let result = try await invoke(params: params)
        switch onEnum(of: result) {
        case let .success(success): return success.data as! Void
        case let .error(error): throw error.error.asError
        }
    }
}

public extension UseCaseResultNoParams {
    func execute<Out>() async throws -> Out {
        let result = try await invoke()
        switch onEnum(of: result) {
        case let .success(success): return success.data as! Out
        case let .error(error): throw error.error.asError
        }
    }
    
    // Void returining UC
    func execute() async throws {
        let result = try await invoke()
        switch onEnum(of: result) {
        case let .success(success): return success.data as! Void
        case let .error(error): throw error.error.asError
        }
    }
}
