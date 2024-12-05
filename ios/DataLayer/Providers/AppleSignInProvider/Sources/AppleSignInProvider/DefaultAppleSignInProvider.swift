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

extension DefaultAppleSignInProvider: AppleSignInProvider {
    public func __readAppleCredential() async throws -> Result<ExternalProviderCredential> {
        let rawNonce = CryptoUtility.randomNonceString()
        let hashedNonce = CryptoUtility.sha256(rawNonce)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        request.nonce = hashedNonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        do {
            let idToken = try await withCheckedThrowingContinuation({ [weak self] (continuation: AppleAuthContinuation) in
                guard let self else { return }
                
                appleAuthContinuation = continuation
                authorizationController.performRequests()
            })
            
            return ResultSuccess(data: ExternalProviderCredential(
                idToken: idToken,
                accessToken: nil,
                rawNonce: rawNonce,
                hashedNonce: hashedNonce
            ))
        } catch {
            let fallbackError = ResultError<ExternalProviderCredential>(error: AuthError.ExternalError(message: nil))
            
            guard let authError = error as? ASAuthorizationError else {
                return fallbackError
            }
            
            switch authError.code {
            case .canceled: return ResultError(error: AuthError.ExternalFlowCancelled())
            default: return fallbackError
            }
        }
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
        appleAuthContinuation?.resume(throwing: error)
        appleAuthContinuation = nil
    }
}
