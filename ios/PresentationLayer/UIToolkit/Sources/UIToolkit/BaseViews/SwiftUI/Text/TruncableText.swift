//
//  Created by Tomáš Batěk on 11.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI


/// Inspired by https://www.fivestars.blog/articles/trucated-text/
public struct TruncableText: View {
    
    private let text: Text
    private let lineLimit: Int?
    private let isTruncatedUpdate: (_ isTruncated: Bool) -> Void
    
    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    
    public init(
        text: Text,
        lineLimit: Int?,
        isTruncatedUpdate: @escaping (_: Bool) -> Void
    ) {
        self.text = text
        self.lineLimit = lineLimit
        self.isTruncatedUpdate = isTruncatedUpdate
    }
    
    public var body: some View {
        text
            .lineLimit(lineLimit)
            .readSize { size in
                truncatedSize = size
                isTruncatedUpdate(truncatedSize != intrinsicSize)
            }
            .background(
                text
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .readSize { size in
                        intrinsicSize = size
                        isTruncatedUpdate(truncatedSize != intrinsicSize)
                    }
            )
    }
}
