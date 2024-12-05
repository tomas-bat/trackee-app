//
//  Created by Tomáš Batěk on 20.09.2023
//  Copyright © 2023 Heureka Group a.s. All rights reserved.
//

import SwiftUI

/// A scroll view that centers its content in the parent view, if the parent view is larger that the content.
public struct CenteredScrollView<Content: View>: View {
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: Content
    
    @State private var contentSize: CGSize = .zero
    
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content
                .if(axes == .horizontal) { view in
                    view
                        .frame(minWidth: contentSize.width)
                }
                .if(axes != .horizontal) { view in
                    view
                        .frame(minHeight: contentSize.height)
                }
        }
        // We need a geometry reader here, otherwise HorizontalCenteredScrollViewWithGradients
        // doesn't render its body correctly (its height is wrong).
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        contentSize = geo.size
                    }
            }
        )
    }
}

#if DEBUG
struct CenteredScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CenteredScrollView {
            HStack {
                Spacer()
                
                VStack(spacing: 16) {
                    ForEach(0..<100, id: \.self) { _ in
                        Text("Lorem Ipsum")
                    }
                    
                    Button("Click me!") {}
                }
                .padding()
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Spacer()
            }
        }
        
    }
}
#endif
