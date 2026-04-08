//
//  AppView.swift
//  Libraries
//
//  Created by wepie on 2026/4/8.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            Tab("Gallery", systemImage: "magnifyingglass") {
                GalleryView()
            }
        }
    }
}
