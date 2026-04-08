//
//  RepositoryService.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import CommonDefines
import Foundation
import Factory

public extension Container {
    @MainActor
    var ratingRepositoryService: Factory<RatingRepositoryService> {
        self {
            RatingRepositoryServiceImpl()
        }
        .singleton
        .onPreview {
            MockRatingRepositoryService()
        }
    }
}

@preconcurrency
@MainActor
final class MockRatingRepositoryService: RatingRepositoryService {
    private var cache: [DesignSystem: DesignSystemRatingSubmission]
    fileprivate var continuations = [DesignSystem: [UUID: RatingSubmissionContinuation]]()

    init(
        cache: [DesignSystem: DesignSystemRatingSubmission] = MockRatingRepository.initialCache
    ) {
        self.cache = cache
    }

    func ratingSubmission(for designSystem: CommonDefines.DesignSystem) -> CommonDefines.DesignSystemRatingSubmission? {
        cache[designSystem]
    }

    func ratingSubmissionUpdates(
        for designSystem: CommonDefines.DesignSystem
    ) -> AsyncStream<CommonDefines.DesignSystemRatingSubmission?> {
        makeRatingSubmissionStream(for: designSystem)
    }

    func store(_ ratingSubmission: CommonDefines.DesignSystemRatingSubmission) {
        cache[ratingSubmission.designSystem] = ratingSubmission
        yield(ratingSubmission, for: ratingSubmission.designSystem)
    }
}

@preconcurrency
@MainActor
final class RatingRepositoryServiceImpl: RatingRepositoryService {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private var cache = [DesignSystem: DesignSystemRatingSubmission]()
    fileprivate var continuations = [DesignSystem: [UUID: RatingSubmissionContinuation]]()

    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    func ratingSubmission(for designSystem: DesignSystem) -> DesignSystemRatingSubmission? {
        if let submission = cache[designSystem] {
            return submission
        }

        guard let data = userDefaults.data(
            forKey: designSystem.ratingSubmissionStorageKey
        ) else {
            return nil
        }

        guard let submission = try? decoder.decode(
            DesignSystemRatingSubmission.self,
            from: data
        ) else {
            userDefaults.removeObject(forKey: designSystem.ratingSubmissionStorageKey)
            return nil
        }

        cache[designSystem] = submission
        return submission
    }

    func ratingSubmissionUpdates(
        for designSystem: DesignSystem
    ) -> AsyncStream<DesignSystemRatingSubmission?> {
        makeRatingSubmissionStream(for: designSystem)
    }

    func store(_ ratingSubmission: DesignSystemRatingSubmission) {
        cache[ratingSubmission.designSystem] = ratingSubmission

        if let data = try? encoder.encode(ratingSubmission) {
            userDefaults.set(
                data,
                forKey: ratingSubmission.designSystem.ratingSubmissionStorageKey
            )
        }

        yield(ratingSubmission, for: ratingSubmission.designSystem)
    }
}

private typealias RatingSubmissionContinuation =
    AsyncStream<DesignSystemRatingSubmission?>.Continuation

@MainActor
private protocol RatingSubmissionStreaming: AnyObject, Sendable {
    var continuations: [DesignSystem: [UUID: RatingSubmissionContinuation]] { get set }
    func ratingSubmission(for designSystem: DesignSystem) -> DesignSystemRatingSubmission?
}

@MainActor
private extension RatingSubmissionStreaming {
    func makeRatingSubmissionStream(
        for designSystem: DesignSystem
    ) -> AsyncStream<DesignSystemRatingSubmission?> {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            let id = UUID()
            let currentSubmission = ratingSubmission(for: designSystem)
            continuations[designSystem, default: [:]][id] = continuation

            continuation.yield(currentSubmission)
            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in
                    self?.continuations[designSystem]?[id] = nil
                    if self?.continuations[designSystem]?.isEmpty == true {
                        self?.continuations[designSystem] = nil
                    }
                }
            }
        }
    }

    func yield(
        _ ratingSubmission: DesignSystemRatingSubmission,
        for designSystem: DesignSystem
    ) {
        let currentContinuations = Array(continuations[designSystem, default: [:]].values)
        for continuation in currentContinuations {
            continuation.yield(ratingSubmission)
        }
    }
}

extension MockRatingRepositoryService: RatingSubmissionStreaming {}
extension RatingRepositoryServiceImpl: RatingSubmissionStreaming {}

private extension DesignSystem {
    var ratingSubmissionStorageKey: String {
        let identifier: String = switch self {
        case .charcoal:
            "charcoal"
        case .structura:
            "structura"
        }

        return "DesignSystem.\(identifier).ratingSubmission"
    }
}

private enum MockRatingRepository {
    static var initialCache: [DesignSystem: DesignSystemRatingSubmission] {
        [
            .charcoal: .init(
                designSystem: .charcoal,
                responses: [
                    .init(dimension: .overallImpression, value: .rating(5)),
                    .init(dimension: .consistency, value: .rating(4)),
                    .init(dimension: .aesthetics, value: .rating(5)),
                    .init(dimension: .componentCompleteness, value: .rating(3)),
                    .init(dimension: .missingComponents, value: .openText("Date picker, empty state"))
                ],
                submittedAt: .distantPast
            ),
            .structura: .init(
                designSystem: .structura,
                responses: [
                    .init(dimension: .overallImpression, value: .rating(4)),
                    .init(dimension: .consistency, value: .rating(5)),
                    .init(dimension: .aesthetics, value: .rating(4)),
                    .init(dimension: .componentCompleteness, value: .rating(4)),
                    .init(dimension: .missingComponents, value: .openText("Segmented control"))
                ],
                submittedAt: .distantPast
            )
        ]
    }
}
