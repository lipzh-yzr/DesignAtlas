import Foundation
import Testing
import CommonDefines
import Factory
import FactoryTesting
import RepositoryService

@testable import RatingFeature

@MainActor
@Suite(.container)
struct RatingFeatureTests {
    @Test
    func initWithoutSubmissionBuildsEmptySurveyEntries() {
        let sut = RatingViewModel(designSystem: .charcoal, isFresh: true)

        #expect(sut.designSystem == .charcoal)
        #expect(sut.navigationTitle == "Survey - Charcoal")
        #expect(sut.surveyEntries.count == DesignSystemRatingDimension.allCases.count)
        #expect(sut.surveyEntries.map(\.dimension) == DesignSystemRatingDimension.allCases)
        #expect(sut.surveyEntries.allSatisfy { $0.value == nil })
    }

    @Test
    func submitIfPossibleStoresValidResponses() {
        let repository = RatingRepositoryServiceSpy()
        Container.shared.ratingRepositoryService.register { repository }

        let sut = RatingViewModel(designSystem: .charcoal)
        applyValidResponses(to: sut)

        sut.submitIfPossible()

        #expect(repository.storedSubmissions.count == 1)
        #expect(repository.storedSubmissions.first?.designSystem == .charcoal)
        #expect(
            repository.storedSubmissions.first?.responses.map(\.value) == [
                .rating(5),
                .rating(4),
                .rating(4),
                .rating(3),
                .openText("Date picker")
            ]
        )
        #expect(sut.presentingToast == false)
        expectNoSubmitError(sut.error)
    }

    @Test
    func submitIfPossibleShowsErrorAndSkipsStoreForInvalidResponses() {
        let repository = RatingRepositoryServiceSpy()
        Container.shared.ratingRepositoryService.register { repository }

        let sut = RatingViewModel(designSystem: .structura)
        applyValidResponses(to: sut)
        sut.surveyEntries[0].value = nil

        sut.submitIfPossible()

        #expect(repository.storedSubmissions.isEmpty)
        #expect(sut.presentingToast)

        guard case let .invalidResponse(dimension)? = sut.error else {
            Issue.record("Expected an invalid response error.")
            return
        }

        #expect(dimension == .overallImpression)
    }

    @Test
    func dismissingToastClearsSubmitError() {
        let sut = RatingViewModel(designSystem: .charcoal, isFresh: true)

        sut.presentingToast = true
        sut.error = .invalidResponse(dimension: .consistency)

        sut.presentingToast = false

        expectNoSubmitError(sut.error)
    }
}

@MainActor
private final class RatingRepositoryServiceSpy: RatingRepositoryService, Sendable {
    private(set) var storedSubmissions: [DesignSystemRatingSubmission] = []

    func ratingSubmission(for designSystem: DesignSystem) -> DesignSystemRatingSubmission? {
        storedSubmissions.last { $0.designSystem == designSystem }
    }

    func ratingSubmissionUpdates(
        for designSystem: DesignSystem
    ) -> AsyncStream<DesignSystemRatingSubmission?> {
        let currentSubmission = ratingSubmission(for: designSystem)
        return AsyncStream { continuation in
            continuation.yield(currentSubmission)
            continuation.finish()
        }
    }

    func store(_ ratingSubmission: DesignSystemRatingSubmission) {
        storedSubmissions.append(ratingSubmission)
    }
}

@MainActor
private func applyValidResponses(to viewModel: RatingViewModel) {
    let validAnswers: [DesignSystemRatingDimension: DesignSystemRatingAnswerValue] = [
        .overallImpression: .rating(5),
        .consistency: .rating(4),
        .aesthetics: .rating(4),
        .componentCompleteness: .rating(3),
        .missingComponents: .openText("Date picker")
    ]

    for entry in viewModel.surveyEntries {
        entry.value = validAnswers[entry.dimension]
    }
}

private func expectNoSubmitError(_ error: RatingViewModel.SubmitError?) {
    if case let .some(error) = error {
        Issue.record("Expected no submit error, got: \(String(describing: error))")
    }
}
