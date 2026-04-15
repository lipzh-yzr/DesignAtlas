//
//  GalleryViewModel.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI
import Factory
import RepositoryService
import CommonDefines
import Utils

@MainActor
@Observable
final class GalleryViewModel {
    @Injected(\.ratingRepositoryService) @ObservationIgnored var ratingRepositoryService
    let designSystems: [DesignSystem]
    var designSystemRatings: [DesignSystemRatingSubmission] = []
    @ObservationIgnored private var submissionTasks: [Task<Void, Never>] = []
    var galleryRouter: Router<GalleryRoute> = .init()
    
    init(designSystems: [DesignSystem] = DesignSystem.allCases) {
        self.designSystems = designSystems
        designSystemRatings = designSystems.map({
            ratingRepositoryService
                .ratingSubmission(for: $0) ?? .init(designSystem: $0, responses: [])
        })
        observeSubmission()
    }

    deinit {
        submissionTasks.forEach {
            $0.cancel()
        }
    }
    
    private func cancelAllTasks() {
        submissionTasks.forEach {
            $0.cancel()
        }
    }

    private func observeSubmission() {
        let ratingRepositoryService = ratingRepositoryService
        cancelAllTasks()
        submissionTasks = designSystems.map(
{ designSystem in
        Task { [weak self] in
                for await submission in ratingRepositoryService.ratingSubmissionUpdates(
                    for: designSystem
                ) {
                    guard let self,
 !Task.isCancelled else {
                        return
                    }
                    guard let index = designSystemRatings.firstIndex(where: { aSubmission in
                        aSubmission.designSystem == designSystem
                    }) else { return }
                    designSystemRatings[index] = submission ?? .init(
                        designSystem: designSystem,
                        responses: []
                    )
                }
            }
        })
    }
    
    func pushRatingView(with designSystem: DesignSystem) {
        galleryRouter.push(.rating(designSystem: designSystem, isFresh: false))
    }
    
    func pushShowcaseView(with designSystem: DesignSystem) {
        galleryRouter.push(.showcase(designSystem: designSystem))
    }
}
