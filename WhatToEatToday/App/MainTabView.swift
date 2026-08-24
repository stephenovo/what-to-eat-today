import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
            }
            .tabItem { Label("今天", systemImage: "sun.max.fill") }

            NavigationStack {
                PantryView()
            }
            .tabItem { Label("冰箱", systemImage: "refrigerator.fill") }

            NavigationStack {
                RecipeListView()
            }
            .tabItem { Label("菜谱", systemImage: "book.pages.fill") }
        }
        .tint(LuluPalette.ink)
    }
}
