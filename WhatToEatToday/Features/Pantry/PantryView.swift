import SwiftUI

struct PantryView: View {
    @Environment(PantryStore.self) private var pantry
    @State private var showingAdd = false
    @State private var showingCameraNote = false
    @State private var query = ""
    @State private var addCategory: IngredientCategory?

    private var filteredItems: [PantryItem] {
        guard !query.isEmpty else { return pantry.items }
        return pantry.items.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    private var foodItems: [PantryItem] {
        filteredItems.filter { itemCategory($0) != .seasoning }
    }

    private var seasoningItems: [PantryItem] {
        filteredItems.filter { itemCategory($0) == .seasoning }
    }

    private var totalFoodCount: Int {
        pantry.items.filter { itemCategory($0) != .seasoning }.count
    }

    private var totalSeasoningCount: Int {
        pantry.items.filter { itemCategory($0) == .seasoning }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            topSummary
                .padding(.horizontal, LuluLayout.gutter)
                .padding(.top, 8)
                .padding(.bottom, 14)

            if pantry.items.isEmpty {
                emptyState
            } else {
                List {
                    pantrySection(title: "食材", icon: "carrot.fill", items: foodItems)
                    pantrySection(title: "佐料", icon: "takeoutbag.and.cup.and.straw.fill", items: seasoningItems)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(LuluPalette.canvas)
                .searchable(text: $query, prompt: "搜索冰箱里的食材或佐料")
            }
        }
        .background(LuluPalette.canvas.ignoresSafeArea())
        .navigationTitle("我的冰箱")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { LuluBrandMark(compact: true) }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { showingCameraNote = true } label: { Image(systemName: "camera.fill") }
                    .accessibilityLabel("拍照录入")
                Button { openAdd() } label: { Image(systemName: "plus.circle.fill") }
                    .accessibilityLabel("手动添加食材或佐料")
            }
        }
        .sheet(isPresented: $showingAdd) { AddIngredientSheet(initialCategory: addCategory) }
        .sheet(isPresented: $showingCameraNote) { CameraComingSoonView() }
    }

    private var topSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(pantry.items.count)")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                    Text("\(totalFoodCount) 样食材 · \(totalSeasoningCount) 种佐料")
                        .font(.system(size: 12))
                        .foregroundStyle(LuluPalette.sage)
                }
                Spacer()
                Image(systemName: "refrigerator.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(LuluPalette.green)
            }
            HStack(spacing: 10) {
                addButton("添加食材", icon: "carrot.fill") { openAdd() }
                addButton("添加佐料", icon: "takeoutbag.and.cup.and.straw.fill") { openAdd(category: .seasoning) }
            }
        }
        .luluCard()
    }

    private func addButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(LuluPalette.paper)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(LuluPalette.ink, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func pantrySection(title: String, icon: String, items: [PantryItem]) -> some View {
        if !items.isEmpty {
            Section {
                ForEach(items) { item in
                    PantryItemRow(item: item)
                        .listRowBackground(LuluPalette.canvas)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) { pantry.remove(item) } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                }
            } header: {
                Label(title, systemImage: icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(LuluPalette.ink)
                    .textCase(nil)
            }
        }
    }

    private func openAdd(category: IngredientCategory? = nil) {
        addCategory = category
        showingAdd = true
    }

    private func itemCategory(_ item: PantryItem) -> IngredientCategory? {
        item.category ?? IngredientCatalog.definition(for: item.ingredientID)?.category
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Spacer()
            Text("🧊")
                .font(.system(size: 68))
            Text("冰箱还是空白的")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Text("记下家里的食材和佐料，噜噜就能给出更准确的推荐。")
                .font(.system(size: 14))
                .foregroundStyle(LuluPalette.sage)
                .multilineTextAlignment(.center)
            HStack(spacing: 10) {
                Button("添加食材") { openAdd() }
                Button("添加佐料") { openAdd(category: .seasoning) }
            }
            .buttonStyle(.borderedProminent)
            .tint(LuluPalette.ink)
            Spacer()
        }
        .padding(24)
    }
}

private struct PantryItemRow: View {
    @Environment(PantryStore.self) private var pantry
    let item: PantryItem

    var body: some View {
        HStack(spacing: 12) {
            IngredientEmoji(emoji: item.emoji, size: 52)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 7) {
                    Text(item.name)
                        .font(.system(size: 16, weight: .bold))
                    if item.isExpiringSoon, let expiryText = item.expiryText {
                        Text(expiryText)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(LuluPalette.red)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(LuluPalette.red.opacity(0.1), in: Capsule())
                    }
                }
                Text(item.expiryText.map { "保质期 · \($0)" } ?? "未设置保质期")
                    .font(.system(size: 11))
                    .foregroundStyle(LuluPalette.sage)
            }
            Spacer()
            HStack(spacing: 6) {
                Button { pantry.decrement(item) } label: {
                    Image(systemName: "minus")
                        .frame(width: 30, height: 30)
                        .background(LuluPalette.canvas, in: Circle())
                }
                Text(item.quantityText)
                    .font(.system(size: 13, weight: .semibold))
                    .frame(minWidth: 42)
                Button { pantry.increment(item) } label: {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .background(LuluPalette.yellowSoft, in: Circle())
                }
            }
            .foregroundStyle(LuluPalette.ink)
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(LuluPalette.paper, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(LuluPalette.line, lineWidth: 1)
        }
    }
}
