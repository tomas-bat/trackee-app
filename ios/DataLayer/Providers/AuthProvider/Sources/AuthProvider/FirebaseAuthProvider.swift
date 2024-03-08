//
//  Created by Tomáš Batěk on 08.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import KMPSharedDomain
import DataUtilities

public final class FirebaseAuthProvider {
    
    private typealias AuthContinuation = CheckedContinuation<LoginResponse, Error>
    
    public init() {
        // Start Firebase if not yet started
        FirebaseSetup.setup()
    }
}

extension FirebaseAuthProvider: AuthProvider, KMPSharedDomain.AuthProvider {
    public func __signIn(
        providerType: ExternalLoginType,
        providerCredential: ExternalProviderCredential
    ) async throws -> LoginResponse {
        var credential: AuthCredential {
            switch providerType {
            case .apple:
                OAuthProvider.credential(
                    withProviderID: providerType.getProviderId(),
                    idToken: providerCredential.idToken,
                    rawNonce: providerCredential.rawNonce
                )
            }
        }
        
        return try await withCheckedThrowingContinuation { (continuation: AuthContinuation) in
            Auth.auth().signIn(with: credential) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let result {
                    continuation.resume(
                        returning: LoginResponse(
                            userUid: result.user.uid
                        )
                    )
                } else {
//                    continuation.resume(throwing: LocalizedError)
                }
            }
        }
    }
}
