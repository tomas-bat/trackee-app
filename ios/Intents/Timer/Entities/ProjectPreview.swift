//
//  Created by Tomáš Batěk on 17.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import AppIntents
@preconcurrency import Factory
import Foundation
@preconcurrency import KMPSharedDomain
import UIToolkit
import Utilities

// MARK: - Entity

struct ProjectPreviewEntity: AppEntity, Identifiable {
    
    let id: String
    let name: String
    let clientName: String
    let type: ProjectType?
    
    var displayRepresentation: DisplayRepresentation {
        var image: DisplayRepresentation.Image? {
            guard let type else { return nil }
            return .init(systemName: type.imageSystemName)
        }
        
        return DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(clientName)",
            image: image
        )
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "start_timer_project_parameter_type")
    }
    
    static var defaultQuery = ProjectPreviewEntityQuery()
}

extension ProjectPreview {
    var asEntity: ProjectPreviewEntity {
        ProjectPreviewEntity(
            id: "\(client.id)-\(id)",
            name: name,
            clientName: client.name,
            type: type
        )
    }
}

extension [ProjectPreview] {
    var asEntities: [ProjectPreviewEntity] {
        map { $0.asEntity }
    }
}

extension ProjectPreviewEntity {
    var clientId: String? {
        guard let clientId = id.split(separator: "-").first else { return nil }
        return String(clientId)
    }
    
    var projectId: String? {
        guard let projectId = id.split(separator: "-").last else { return nil }
        return String(projectId)
    }
}

// MARK: - Query

struct ProjectPreviewEntityQuery: EntityQuery/*, EntityStringQuery*/ {
    
    @Injected(\.getProjectPreviewUseCase) private var getProjectPreviewUseCase
    @Injected(\.getProjectsUseCase) private var getProjectsUseCase
    
    // MARK: Suggested
    
    func suggestedEntities() async throws -> [ProjectPreviewEntity] {
        try await fetchProjects().asEntities
    }
    
    // MARK: Query by IDs
    
    func entities(
        for identifiers: [String]
    ) async throws -> [ProjectPreviewEntity] {
        try await identifiers.asyncMap { joinedId -> ProjectPreviewEntity? in
            let ids = joinedId.split(separator: "-")
            guard let clientId = ids.first,
                  let projectId = ids.last
            else { return nil }
            
            let params = GetProjectPreviewUseCaseParams(
                clientId: String(clientId),
                projectId: String(projectId)
            )
            
            let projectPreview: ProjectPreview = try await getProjectPreviewUseCase.execute(params: params)
            return projectPreview.asEntity
        }.compactMap { $0 }
    }
    
    // MARK: Query by String
/// Uncomment the following code and the `EntityStringQuery` conformance of this struct to allow searching by String.
/// It's disabled for now, because using this feature does not show any loading in Shortcuts, which makes the UI seem unresponsive.
/// Either Apple has to fix this, or we'll have to use local cache for projects.
//
//    func entities(matching string: String) async throws -> [ProjectPreviewEntity] {
//        return try await fetchProjects().filter { project in
//            let expr = string
//                .filter { !$0.isWhitespace }
//                .lowercased()
//            
//            return project.name
//                .filter { !$0.isWhitespace }
//                .lowercased()
//                .contains(expr)
//            || project.client.name
//                .filter { !$0.isWhitespace }
//                .lowercased()
//                .contains(expr)
//        }.asEntities
//    }
    
    // MARK: - Private
    
    private func fetchProjects() async throws -> [ProjectPreview] {
        try await getProjectsUseCase.execute()
    }
}
