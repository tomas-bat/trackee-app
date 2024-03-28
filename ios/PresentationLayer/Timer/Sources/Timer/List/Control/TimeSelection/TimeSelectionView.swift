//
//  Created by Tomáš Batěk on 28.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct TimeSelectionView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let pickerLabel = ""
    private let pickerWidth: CGFloat = 320
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: TimeSelectionViewModel
    
    // MARK: - Init
    
    init(viewModel: TimeSelectionViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                
                Text(L10n.time_selection_view_start_label)
                
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
                
                Text(L10n.time_selection_view_end_label)
                
                DatePicker(
                    pickerLabel,
                    selection: Binding<Date>(
                        get: { viewModel.state.end },
                        set: { end in viewModel.onIntent(.onEndChange(end)) }
                    ),
                    in: viewModel.state.endRange,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .frame(width: pickerWidth)
                
                Text(viewModel.state.formattedLength ?? "")
                
                Spacer()
            }
            .padding(padding)
            .frame(maxWidth: .infinity)
            .datePickerStyle(.wheel)
            .font(AppTheme.Fonts.headline)
            .foregroundStyle(AppTheme.Colors.foreground)
            .navigationTitle(L10n.time_selection_view_title)
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
    
    let vm = TimeSelectionViewModel(
        initialStart: Date(timeIntervalSinceNow: -10_000),
        initialEnd: .now
    )
    
    return Text("Base View")
        .sheet(isPresented: .constant(true)) {
            TimeSelectionView(viewModel: vm)
        }
}

#endif
