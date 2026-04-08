//
//  GalleryRouting.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI
import Utils

public enum GalleryRoute: Hashable {
    case showcase(designSystem: DesignSystem) // 对该系统的展示页
    case rating(designSystem: DesignSystem, isFresh: Bool) // 对该系统的评测页。isFresh: 是否展示空白的，而不是填充已有数据的评测问卷
}

@MainActor
private struct GalleryRouterEnvironmentKey: @preconcurrency EnvironmentKey {
    static let defaultValue = Router<GalleryRoute>()
}

public extension EnvironmentValues {
    var galleryRouter: Router<GalleryRoute> {
        get { self[GalleryRouterEnvironmentKey.self] }
        set { self[GalleryRouterEnvironmentKey.self] = newValue }
    }
}
