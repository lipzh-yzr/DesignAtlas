//
//  Router.swift
//  Libraries
//
//  Created by wepie on 2026/3/31.
//

import SwiftUI

@MainActor
@Observable
final class Router<Route: Hashable> {
    var routes: [Route] = []
    func push(_ route: Route) {
        routes.append(route)
    }
    
    func pop() {
        _ = routes.popLast()
    }
    
    func popToRoot() {
        routes.removeAll()
    }
    
    func setPath(_ path: [Route]) {
        routes = path
    }
}
