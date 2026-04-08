//
//  RatingFeature.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import CommonDefines
import Observation
import Factory
import RepositoryService

@Observable
class RatingViewModel {
    @Observable
    class SurveyEntry: Identifiable {
        let question: DesignSystemRatingQuestion
        var value: DesignSystemRatingAnswerValue?

        var id: DesignSystemRatingDimension {
            question.dimension
        }
        
        var dimension: DesignSystemRatingDimension {
            question.dimension
        }
        
        init(
            question: DesignSystemRatingQuestion,
            value: DesignSystemRatingAnswerValue? = nil
        ) {
            self.question = question
            self.value = value
        }
    }

    enum SubmitError: Error {
        case invalidResponse(dimension: DesignSystemRatingDimension)
    }
    /// 目前的答案
    let designSystem: DesignSystem
    @Injected(\.ratingRepositoryService) private var ratingRepositoryService
    var presentingToast = false {
        didSet {
            if !presentingToast {
                error = nil
            }
        }
    }
    var error: SubmitError? = nil
    
    init(
        designSystem: DesignSystem,
        isFresh: Bool
    ) {
        self.designSystem = designSystem
        let submission = isFresh ? nil : ratingRepositoryService.ratingSubmission(
            for: designSystem
        )
        let survey = DesignSystemRatingSurvey(designSystem: designSystem)
        self.surveyEntries = Self.normalizedResponses(
            from: submission?.responses,
            survey: survey
        )
    }

    var surveyEntries: [SurveyEntry]
    
    func submitIfPossible() {
        for entry in surveyEntries {
            if !entry.question.accepts(entry.value) {
                presentingToast = true
                error = .invalidResponse(dimension: entry.dimension)
                return
            }
        }
        
        let responses: [DesignSystemRatingResponse] = surveyEntries.map {
            .init(dimension: $0.dimension, value: $0.value)
        }
        let submission = DesignSystemRatingSubmission(
            designSystem: designSystem,
            responses: responses
        )
        ratingRepositoryService.store(submission)
    }

    private static func normalizedResponses(
        from responses: [DesignSystemRatingResponse]?,
        survey: DesignSystemRatingSurvey
    ) -> [SurveyEntry] {
        survey.questions.map { question in
            let responseVal = responses?.first(where: { $0.dimension == question.dimension })?.value ?? nil
            return .init(question: question, value: responseVal)
        }
    }
    
    var navigationTitle: String {
        "Survey - \(designSystem.title)"
    }
}
