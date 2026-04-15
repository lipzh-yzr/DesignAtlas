//
//  AppView.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI

public struct AppView: View {
    public init() {}
    public var body: some View {
        TabView {
            Tab("Gallery", systemImage: "magnifyingglass") {
                GalleryView()
            }
        }
    }
}
