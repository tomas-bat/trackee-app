//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation

public enum ViewData<Data: Equatable>: Equatable {
    
    case data(Data)
    case error(Error)
    case loading(mock: Data)
    case empty
    
    public var isLoading: Bool {
        switch self {
        case .loading: true
        default: false
        }
    }
    
    public var isError: Bool {
        switch self {
        case .error: true
        default: false
        }
    }
    
    public var hasData: Bool {
        switch self {
        case .data: true
        default: false
        }
    }
    
    public static func == (lhs: ViewData<Data>, rhs: ViewData<Data>) -> Bool {
        switch (lhs, rhs) {
        case let (.data(ldata), .data(rdata)): ldata == rdata
        case let (.error(lerror), .error(rerror)): lerror.localizedDescription == rerror.localizedDescription
        case let (.loading(ldata), .loading(rdata)): ldata == rdata
        case (.empty, .empty): true
        default: false
        }
    }
}
