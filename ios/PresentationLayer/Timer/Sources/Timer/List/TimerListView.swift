//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct TimerListView: View {
    
    // MARK: - Constants
    
    private let entrySpacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: TimerListViewModel
    
    // MARK: - Init
    
    init(viewModel: TimerListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: entrySpacing) {
                
            }
        }
        .background(AppTheme.Colors.background)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VStack(alignment: .leading) {
                    Text("7h 26m Today")
                    
                    Text("31h 13m This week")
                }
                
                Spacer()
            }
        }
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = TimerListViewModel()
    return NavigationView {
        TimerListView(viewModel: vm)
    }
}
#endif
