//
//  Created by Petr Chmelar on 08/10/2018.
//  Copyright © 2018 Matee. All rights reserved.
//

import DatabaseProvider
import NetworkProvider
import SharedDomain

public struct UserRepositoryImpl: UserRepository {
    
    private let database: DatabaseProvider
    private let network: NetworkProvider
    
    public init(
        databaseProvider: DatabaseProvider,
        networkProvider: NetworkProvider
    ) {
        database = databaseProvider
        network = networkProvider
    }
    
    public func read(_ sourceType: SourceType, id: String) async throws -> User {
        switch sourceType {
        case .local:
            return try database.read(DBUser.self, id: id).domainModel
        case .remote:
            let endpoint = UserAPI.read(id)
            let user = try await network.request(endpoint).map(NETUser.self).domainModel
            return try database.update(user.databaseModel).domainModel
        }
    }
    
    public func read(_ sourceType: SourceType, page: Int, sortBy: String?) async throws -> [User] {
        switch sourceType {
        case .local:
            return try database.read(DBUser.self, sortBy: sortBy).map { $0.domainModel }
        case .remote:
            let endpoint = UserAPI.list(page)
            let users = try await network.request(endpoint).map([NETUser].self, atKeyPath: "data").map { $0.domainModel }
            try database.update(users.map { $0.databaseModel })
            return users
        }
    }
    
    public func update(_ sourceType: SourceType, user: User) async throws -> User {
        switch sourceType {
        case .local:
            return try database.update(user.databaseModel, model: .fullModel).domainModel
        case .remote:
            let data = try user.networkModel.encode()
            let endpoint = UserAPI.update(user.id, data: data)
            let user = try await network.request(endpoint).map(NETUser.self).domainModel
            return try database.update(user.databaseModel).domainModel
        }
    }
}
