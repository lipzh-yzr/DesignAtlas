//
//  Router.swift
//  Libraries
//
//  Created by wepie on 2026/3/31.
//

import SwiftUI

@MainActor
@Observable
public final class Router<Route: Hashable> {
    var routes: [Route]
    
    public init(routes: [Route] = []) {
        self.routes = routes
    }
    
    public func push(_ route: Route) {
        routes.append(route)
    }
    
    public func pop() {
        _ = routes.popLast()
    }
    
    public func popToRoot() {
        routes.removeAll()
    }
    
    public func setPath(_ path: [Route]) {
        routes = path
    }
}
