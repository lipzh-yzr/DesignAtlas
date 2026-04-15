//
//  SystemShowcaseViewModel.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI
import CommonDefines
import Factory
import RepositoryService
import Utils

@MainActor
@Observable
class SystemShowcaseViewModel {
    let designSystem: DesignSystem
    
    @Injected(\.ratingRepositoryService) @ObservationIgnored var ratingRepositoryService
    @ObservationIgnored private var submissionTask: Task<Void, Never>?
    
    var submission: DesignSystemRatingSubmission?
    
    var router: Router<GalleryRoute>?
    
    init(designSystem: DesignSystem) {
        self.designSystem = designSystem
        observeSubmission()
    }

    deinit {
        submissionTask?.cancel()
    }

    private func observeSubmission() {
        let designSystem = designSystem
        let ratingRepositoryService = ratingRepositoryService
        submissionTask?.cancel()
        submissionTask = Task { [weak self] in
            for await submission in ratingRepositoryService.ratingSubmissionUpdates(
                for: designSystem
            ) {
                guard !Task.isCancelled else {
                    return
                }
                self?.submission = submission
            }
        }
    }
    
    func pushRatingView(isFresh: Bool) {
        router?.push(.rating(designSystem: designSystem, isFresh: isFresh))
    }
}
