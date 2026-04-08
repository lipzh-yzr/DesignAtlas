//
//  RepositoryServiceInterface.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import Foundation
import CommonDefines

@MainActor
public protocol RatingRepositoryService {
    func ratingSubmission(for designSystem: DesignSystem) -> DesignSystemRatingSubmission?
    func ratingSubmissionUpdates(for designSystem: DesignSystem) -> AsyncStream<DesignSystemRatingSubmission?>
    func store(_ ratingSubmission: DesignSystemRatingSubmission)
}
