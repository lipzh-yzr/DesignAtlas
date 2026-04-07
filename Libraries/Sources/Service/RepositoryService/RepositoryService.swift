//
//  RepositoryService.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import CommonDefines
import Foundation
import ServiceInterface
import Factory

public extension Container {
    var ratingRepositoryService: Factory<RatingRepositoryService> {
        self {
            RatingRepositoryServiceImpl()
        }.onTest {
            MockRatingRepositoryService()
        }.onPreview {
            MockRatingRepositoryService()
        }
    }
}

final class MockRatingRepositoryService: RatingRepositoryService {
    private var cache: [DesignSystem: DesignSystemRatingSubmission]

    init(cache: [DesignSystem: DesignSystemRatingSubmission] = Self.initialCache) {
        self.cache = cache
    }

    func ratingSubmission(for designSystem: CommonDefines.DesignSystem) -> CommonDefines.DesignSystemRatingSubmission? {
        cache[designSystem]
    }

    func store(_ ratingSubmission: CommonDefines.DesignSystemRatingSubmission) {
        cache[ratingSubmission.designSystem] = ratingSubmission
    }
}

final class RatingRepositoryServiceImpl: RatingRepositoryService {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

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
        guard let data = userDefaults.data(forKey: designSystem.ratingSubmissionStorageKey) else {
            return nil
        }

        guard let submission = try? decoder.decode(DesignSystemRatingSubmission.self, from: data) else {
            userDefaults.removeObject(forKey: designSystem.ratingSubmissionStorageKey)
            return nil
        }

        return submission
    }

    func store(_ ratingSubmission: DesignSystemRatingSubmission) {
        guard let data = try? encoder.encode(ratingSubmission) else {
            return
        }

        userDefaults.set(data, forKey: ratingSubmission.designSystem.ratingSubmissionStorageKey)
    }
}

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

private extension MockRatingRepositoryService {
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
