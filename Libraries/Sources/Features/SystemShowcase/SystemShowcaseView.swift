//
//  SystemShowcaseView.swift
//  Libraries
//
//  Created by wepie on 2026/4/5.
//

import SwiftUI
import CommonDefines
import CharcoalUI
import StructuraUI

public struct SystemShowcaseView: View {
    
    @State var viewModel: SystemShowcaseViewModel
    
    @Environment(\.galleryRouter) var galleryRouter
    
    public init(_ designSystem: DesignSystem) {
        self.viewModel = .init(designSystem: designSystem)
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                headerView()
                switch viewModel.designSystem {
                case .charcoal:
                    CharcoalView()
                case .structura:
                    StructuraView()
                }
            }.frame(maxWidth: .infinity)
        }
        .onAppear {
            viewModel.router = galleryRouter
        }
    }
    
    func headerView() -> some View {
        HStack {
            Text("Showcase - \(viewModel.designSystem.title)")
                .frame(alignment: .center)
            Button("Take Survey", systemImage: "printer") {
                viewModel.pushRatingView(isFresh: true)
            }
            .foregroundStyle(stColor: .white)
            .background(stColor: .brandBg)
            .buttonBorderShape(.capsule)
            .frame(alignment: .trailing)
        }.frame(maxWidth: .infinity)
    }
}
