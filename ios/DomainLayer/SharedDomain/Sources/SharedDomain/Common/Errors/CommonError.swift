import Foundation
import KMPSharedDomain

public struct KMPError: Error {
    public let kmpError: ErrorResult
    
    public init(_ kmpError: ErrorResult) {
        self.kmpError = kmpError
    }
}
