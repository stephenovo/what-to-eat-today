import SwiftUI

@main
struct WhatToEatTodayApp: App {
    @State private var pantry = PantryStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(pantry)
                .preferredColorScheme(.light)
        }
    }
}
