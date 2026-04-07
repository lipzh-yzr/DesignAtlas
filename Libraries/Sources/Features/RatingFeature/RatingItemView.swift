//
//  RatingItemView.swift
//  Libraries
//
//  Created by wepie on 2026/4/6.
//

import SwiftUI
import CommonDefines
import CharcoalSwiftUI

struct RatingItemView: View {
    @Binding var entry: RatingViewModel.SurveyEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.question.dimension.title)
                .charcoalTypography14Bold(isSingleLine: true)
                .charcoalOnSurfaceText1()
        }
    }
    
    private func questionDescription(for question: DesignSystemRatingQuestion) -> String {
        let requirement = question.isRequired ? "Required" : "Optional"

        switch question.kind {
        case let .rating(scale):
            return "\(requirement) • Rating \(scale.minScore)-\(scale.maxScore)"
        case let .openText(configuration):
            if let placeholder = configuration.placeholder, !placeholder.isEmpty {
                return "\(requirement) • \(placeholder)"
            }

            return "\(requirement) • Open text"
        }
    }
}
