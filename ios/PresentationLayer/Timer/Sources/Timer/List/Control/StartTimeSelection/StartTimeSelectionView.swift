//
//  Created by Tomáš Batěk on 11.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct StartTimeSelectionView: View {
    
    // MARK: Constants
    
    private let padding: CGFloat = 16
    private let pickerWidth: CGFloat = 320
    private let pickerLabel = ""
    
    // MARK: Stored properties
    
    @ObservedObject private var viewModel: StartTimeSelectionViewModel
    
    // MARK: - Init
    
    init(viewModel: StartTimeSelectionViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                
                Text(L10n.start_time_selection_view_start_label)
                
                DatePicker(
                    pickerLabel,
                    selection: Binding<Date>(
                        get: { viewModel.state.start },
                        set: { start in viewModel.onIntent(.onStartChange(start)) }
                    ),
                    in: viewModel.state.startRange,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .frame(width: pickerWidth)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .datePickerStyle(.wheel)
            .font(AppTheme.Fonts.headline)
            .foregroundStyle(AppTheme.Colors.foreground)
            .navigationTitle(L10n.start_time_selection_view_title)
            .navigationBarTitleDisplayMode(.inline)
            .snack(viewModel.snackState)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        viewModel.onIntent(.dismiss)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(L10n.save_label) {
                        viewModel.onIntent(.save)
                    }
                }
            }
            .background(AppTheme.Colors.background)
            .lifecycle(viewModel)
        }
    }
}

#if DEBUG
import Factory
import DependencyInjectionMocks
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = StartTimeSelectionViewModel(
        initialStart: Date(timeIntervalSinceNow: -10_000)
    )
    
    return Text("Base View")
        .sheet(isPresented: .constant(true)) {
            StartTimeSelectionView(viewModel: vm)
        }
}

#endif
