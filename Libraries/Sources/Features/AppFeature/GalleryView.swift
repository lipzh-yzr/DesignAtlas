//
//  GalleryView.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI
import Utils
import CommonDefines

struct GalleryView: View {
    @State var viewModel: GalleryViewModel = .init()
    var body: some View {
        NavigationStack(path: $viewModel.galleryRouter.routes) {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(viewModel.designSystemRatings) { rating in
                        GalleryItemView(viewModel: viewModel, rating: rating)
                    }
                }
            }.withGalleryRouter()
        }
        .environment(\.galleryRouter, viewModel.galleryRouter)
    }
    
    var gridColumns: [GridItem] {
        [
            .init(.fixed(100), spacing: 8),
            .init(.fixed(100), spacing: 8)
        ]
    }
    
    private struct GalleryItemView: View {
        let viewModel: GalleryViewModel
        let rating: DesignSystemRatingSubmission
        var body: some View {
            ZStack(alignment: .topLeading) {
                Circle()
                    .fill(Gradient(colors: [
                        rating.designSystem.brandColor,
                        rating.designSystem.brandColor.opacity(0)
                    ]))
                    .frame(width: 60, height: 60)
                VStack(spacing: 4) {
                    Text(rating.designSystem.title)
                        .charcoalTypography16Bold(isSingleLine: true)
                    if !rating.isEmpty {
                        Button {
                            viewModel.pushRatingView(with: rating.designSystem)
                        } label: {
                            HStack {
                                Text("Rating: \(rating.generalScore)")
                                Image(systemName: "star")
                            }
                        }.charcoalDefaultButton()
                    }
                }.frame(alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
        }
    }
}

struct GalleryCardView: View {
    var viewModel: GalleryViewModel
    var body: some View {
        
    }
}
