//
//  SystemShowcaseView.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import SwiftUI
import CommonDefines

public struct SystemShowcaseView: View {
    
    @State var viewModel: SystemShowcaseViewModel
    
    public init(_ designSystem: DesignSystem) {
        self.viewModel = .init(designSystem: designSystem)
    }
    
    public var body: some View {
        
    }
}
