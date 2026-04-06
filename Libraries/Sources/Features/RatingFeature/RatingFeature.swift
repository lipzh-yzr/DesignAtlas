//
//  RatingFeature.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import CommonDefines
import SwiftUI
import Observation
import Factory
import RepositoryService

@Observable
class RatingViewModel {
    enum SubmitError: Error {
        case invalidResponse(dimension: DesignSystemRatingDimension)
    }
    /// 目前的答案
    var currentResponses: [DesignSystemRatingResponse]
    let designSystem: DesignSystem
    let survey: DesignSystemRatingSurvey
    @Injected(\.ratingRepositoryService) private var ratingRepositoryService
    
    init(
        currentSubmission: DesignSystemRatingSubmission? = nil,
        designSystem: DesignSystem
    ) {
        self.currentResponses = currentSubmission?.responses ?? DesignSystemRatingDimension.allCases
            .map({
                DesignSystemRatingResponse(dimension: $0)
            })
        self.designSystem = designSystem
        self.survey = .init(designSystem: designSystem)
    }
    
    func update(
        response: DesignSystemRatingAnswerValue?,
        for dimension: DesignSystemRatingDimension
    ) {
        guard let index = currentResponses.firstIndex(where: {
            $0.dimension == dimension
        }) else { return }
        currentResponses[index].value = response
    }
    
    func submitIfPossible() throws(SubmitError) {
        var shouldAccept = true
        for (i, question) in survey.questions.enumerated() {
            let response = currentResponses[i]
            if question.accepts(response.value) {
                throw .invalidResponse(dimension: response.dimension)
            }
        }
        
        let submission = DesignSystemRatingSubmission(
            designSystem: designSystem,
            responses: currentResponses
        )
        ratingRepositoryService.store(submission)
    }
}
