import KMPSharedDomain

public extension ErrorResult {
    var asError: KMPError {
        KMPError(self)
    }
}
