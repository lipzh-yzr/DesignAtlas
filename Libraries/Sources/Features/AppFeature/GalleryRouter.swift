//
//  GalleryRouter.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI
import CommonDefines
import SystemShowcase
import RatingFeature

extension View {
    func withGalleryRouter() -> some View {
        self.navigationDestination(for: GalleryRoute.self) { route in
            switch route {
            case .showcase(let designSystem):
                SystemShowcaseView(designSystem)
            case let .rating(designSystem, isFresh):
                RatingView(designSystem: designSystem, isFresh: isFresh)
            }
        }
    }
}
