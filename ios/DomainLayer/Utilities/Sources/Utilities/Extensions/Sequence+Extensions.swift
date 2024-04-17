//
//  Created by Tomáš Batěk on 17.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation

public extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}
