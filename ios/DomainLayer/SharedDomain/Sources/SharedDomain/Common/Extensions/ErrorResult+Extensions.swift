import KMPSharedDomain

public extension ErrorResult {
    
    var asError: Swift.Error {
        switch self {
        // CommonError
        case is KMPSharedDomain.CommonError.NoNetworkConnection: CommonError.noNetworkConnection
        default: CommonError.unknownError
        }
    }
}
