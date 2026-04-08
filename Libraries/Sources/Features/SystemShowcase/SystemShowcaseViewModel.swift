//
//  SystemShowcaseViewModel.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI
import CommonDefines

@Observable
class SystemShowcaseViewModel {
    let designSystem: DesignSystem
    
    init(designSystem: DesignSystem) {
        self.designSystem = designSystem
    }
}
