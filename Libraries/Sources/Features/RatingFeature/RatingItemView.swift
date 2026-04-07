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
            Text(questionDescription(for: entry.question))
                .charcoalTypography10Regular(isSingleLine: true)
                .charcoalOnSurfaceText3()
            switch entry.question.kind {
            case .rating(let designSystemRatingScale):
                ratingScaleView(with: designSystemRatingScale)
            case .openText(let designSystemOpenTextConfiguration):
                TextField("", text: .init(get: {
                    entry.value?.textAnswer ?? ""
                }, set: { newVal in
                    entry.value = .openText(newVal)
                }))
                    .charcoalTextField(label: .constant(""))
            }
        }
    }
    
    func ratingScaleView(with designSystemRatingScale: DesignSystemRatingScale) -> some View {
        Slider(
            value: .init(get: {
                Double(entry.value?.rating ?? 0)
            }, set: { newVal in
                entry.value = .rating(Int(newVal))
            }),
            in: Double(
                designSystemRatingScale.minScore
            )...Double(designSystemRatingScale.maxScore),
            step: 1,
            label: {
            },
            minimumValueLabel: {
                Text("\(designSystemRatingScale.minScore)")
            },
            maximumValueLabel: {
                Text("\(designSystemRatingScale.maxScore)")
            }
        )
    }
    
    private func questionDescription(for question: DesignSystemRatingQuestion) -> String {
        let requirement = question.isRequired ? "Required" : "Optional"

        switch question.kind {
        case let .rating(scale):
            return "\(requirement) • Rating \(scale.minScore)-\(scale.maxScore)"
        case let .openText(configuration):
            return "\(requirement) • Open text"
        }
    }
}
