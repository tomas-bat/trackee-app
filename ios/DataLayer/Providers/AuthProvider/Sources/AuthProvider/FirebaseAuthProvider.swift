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
    
    public init() {
        // Start Firebase if not yet started
        FirebaseSetup.setup()
    }
}

extension FirebaseAuthProvider: AuthProvider, KMPSharedDomain.AuthProvider {
    
    public func __signIn(
        providerType: ExternalLoginType,
        providerCredential: ExternalProviderCredential
    ) async -> Result<LoginResponse> {
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
        
        do {
            return ResultSuccess(
                data: LoginResponse(
                    idToken: try await Auth.auth().signIn(
                        with: credential
                    ).user.getIDToken()
                )
            )
        } catch {
            return ResultError(
                error: ErrorResult(message: error.localizedDescription)
            )
        }
    }
    
    public func __createUser(
        email: String,
        password: String
    ) async -> Result<LoginResponse> {
        do {
            return ResultSuccess(
                data: LoginResponse(
                    idToken: try await Auth.auth().createUser(
                        withEmail: email,
                        password: password
                    ).user.getIDToken()
                )
            )
        } catch {
            return ResultError(error: ErrorResult(message: error.localizedDescription))
        }
    }
    
    public func __signIn(
        email: String,
        password: String
    ) async -> Result<LoginResponse> {
        do {
            return ResultSuccess(
                data: LoginResponse(
                    idToken: try await Auth.auth().signIn(
                        withEmail: email,
                        password: password
                    ).user.getIDToken()
                )
            )
        } catch {
            switch AuthErrorCode(_nsError: error as NSError).code {
            case .wrongPassword, .invalidCredential: return ResultError(error: AuthError.InvalidLoginCredentials(throwable: nil))
            default: return ResultError(error: ErrorResult(message: error.localizedDescription))
            }
        }
    }
    
    public func __readAccessToken() async -> Result<NSString> {
        guard let accessToken = try? await Auth.auth().currentUser?.getIDToken() else {
            return ResultError(error: AuthError.NoAccessToken())
        }
        
        return ResultSuccess(data: NSString(string: accessToken))
    }
    
    public func __readCurrentUserUid() async -> Result<NSString> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return ResultError(error: AuthError.NoCurrentUser())
        }
        
        return ResultSuccess(data: NSString(string: uid))
    }
    
    public func __logout() async -> Result<KotlinUnit> {
        do {
            try Auth.auth().signOut()
            return ResultSuccess(data: KotlinUnit())
        } catch {
            return ResultError(error: ErrorResult(message: error.localizedDescription))
        }
    }
    
    public func __readUserEmail() async -> Result<NSString> {
        guard let email = Auth.auth().currentUser?.email else {
            return ResultError(error: AuthError.NoCurrentUser())
        }
        return ResultSuccess(data: NSString(string: email))
    }
}
