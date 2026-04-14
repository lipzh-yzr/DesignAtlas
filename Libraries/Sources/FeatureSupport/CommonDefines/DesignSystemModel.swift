//
//  DesignSystemModel.swift
//  Libraries
//
//  Created by wepie on 2026/4/6.
//

import Foundation
import SwiftUI
import CharcoalSwiftUI
import StructuraSwiftUI

public enum DesignSystem: Int, Codable, Hashable, Sendable, CaseIterable {
    case charcoal = 0
    case structura = 1
    
    public var title: String {
        switch self {
        case .charcoal:
            "Charcoal"
        case .structura:
            "Structura"
        }
    }
    
    public var author: String {
        switch self {
        case .charcoal:
            "pixiv"
        case .structura:
            "lipzh-yzr"
        }
    }
    
    public var brandColor: SwiftUI.Color {
        switch self {
        case .charcoal:
            return Color(
                asset: CharcoalAsset.ColorPaletteGenerated.brand.colorAsset
            )
        case .structura:
            return Color(colorPalette: .brandDefault)
        }
    }
}
