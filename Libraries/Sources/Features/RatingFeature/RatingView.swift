//
//  RatingView.swift
//  Libraries
//
//  Created by wepie on 2026/4/6.
//

import SwiftUI
import CommonDefines

public struct RatingView: View {
    @State private var viewModel: RatingViewModel

    public init(
        designSystem: DesignSystem,
        isFresh: Bool
    ) {
        _viewModel = State(
            initialValue: .init(designSystem: designSystem, isFresh: isFresh)
        )
    }
    
    public var body: some View {
        VStack {
            List($viewModel.surveyEntries) { entry in
                RatingItemView(entry: entry)
            }
            .listStyle(.plain)
            Spacer(minLength: 12)
            Button {
                viewModel.submitIfPossible()
            } label: {
                Text("Submit")
            }.charcoalPrimaryButton(isFixed: false)
        }
        .navigationTitle(viewModel.navigationTitle)
        .charcoalToast(
            isPresenting: $viewModel.presentingToast,
            text: viewModel
                .error?.localizedDescription ?? "")
    }
}
