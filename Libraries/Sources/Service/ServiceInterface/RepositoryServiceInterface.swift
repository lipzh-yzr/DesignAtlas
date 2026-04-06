//
//  RepositoryServiceInterface.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import Foundation
import CommonDefines

public protocol RatingRepositoryService {
    func ratingSubmission(for designSystem: DesignSystem) -> DesignSystemRatingSubmission?
    func store(_ ratingSubmission: DesignSystemRatingSubmission)
}
