//
//  Created by Tomáš Batěk on 08.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
import UIKit
import AuthenticationServices
import DataUtilities

public final class DefaultAppleSignInProvider: NSObject {
    
    private typealias AppleAuthContinuation = CheckedContinuation<String, Error>
    
    private let presentationAnchor: UIWindow??
    
    private var appleAuthContinuation: AppleAuthContinuation?
    
    public init(presentationAnchor: UIWindow??) {
        self.presentationAnchor = presentationAnchor
    }
}

extension DefaultAppleSignInProvider: AppleSignInProvider, KMPSharedDomain.AppleSignInProvider {
    public func __readAppleCredential() async throws -> ExternalProviderCredential {
        let rawNonce = CryptoUtility.randomNonceString()
        let hashedNonce = CryptoUtility.sha256(rawNonce)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        request.nonce = hashedNonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        let idToken = try await withCheckedThrowingContinuation({ [weak self] (continuation: AppleAuthContinuation) in
            guard let self else { return }
            
            appleAuthContinuation = continuation
            authorizationController.performRequests()
        })
        
        return ExternalProviderCredential(
            idToken: idToken,
            accessToken: nil,
            rawNonce: rawNonce,
            hashedNonce: hashedNonce
        )
    }
}

extension DefaultAppleSignInProvider: ASAuthorizationControllerDelegate,
                                      ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        (presentationAnchor ?? UIWindow()) ?? UIWindow()
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idToken = appleIDCredential.identityToken,
              let idTokenString = String(data: idToken, encoding: .utf8)
        else {
            appleAuthContinuation = nil
            return
        }
        
        appleAuthContinuation?.resume(returning: idTokenString)
        appleAuthContinuation = nil
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("Apple Authorization Error: \(error)")
//        appleAuthContinuation?.resume(throwing: AuthError.login(.externalAuthError))
        appleAuthContinuation = nil
    }
}
