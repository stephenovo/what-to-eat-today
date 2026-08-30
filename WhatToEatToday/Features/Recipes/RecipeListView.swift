import SwiftUI

struct RecipeListView: View {
    @Environment(PantryStore.self) private var pantry
    @State private var filter: RecipeFilter = .all

    private var recommendations: [RecipeRecommendation] {
        let all = RecommendationEngine.recommendations(pantry: pantry.items)
        return switch filter {
        case .all: all
        case .ready: all.filter { $0.isReady }
        case .almost: all.filter { !$0.isReady && $0.missing.count <= 1 }
        }
    }

    var body: some View {
        LuluPage {
            VStack(alignment: .leading, spacing: 16) {
                header
                    .padding(.top, 8)
                Picker("筛选菜谱", selection: $filter) {
                    ForEach(RecipeFilter.allCases) { value in
                        Text(value.title).tag(value)
                    }
                }
                .pickerStyle(.segmented)

                if recommendations.isEmpty {
                    VStack(spacing: 12) {
                        Text("🍽️").font(.system(size: 58))
                        Text(filter == .ready ? "暂时没有可以直接做的菜" : "没有符合条件的菜谱")
                            .font(.system(size: 17, weight: .bold))
                        Text("再去冰箱里添加一两样食材试试。")
                            .font(.system(size: 13))
                            .foregroundStyle(LuluPalette.sage)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 44)
                    .luluCard()
                } else {
                    ForEach(recommendations) { recommendation in
                        RecipeCard(recommendation: recommendation)
                    }
                }
            }
        }
        .navigationTitle("菜谱灵感")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { LuluBrandMark(compact: true) }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("不纠结，看看现在能做什么")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(LuluPalette.ink)
            Text("推荐只基于你记录在这台手机里的食材和佐料")
                .font(.system(size: 12))
                .foregroundStyle(LuluPalette.sage)
        }
    }
}

private enum RecipeFilter: String, CaseIterable, Identifiable {
    case all
    case ready
    case almost

    var id: String { rawValue }
    var title: String {
        switch self {
        case .all: "全部"
        case .ready: "直接做"
        case .almost: "只缺一样"
        }
    }
}
