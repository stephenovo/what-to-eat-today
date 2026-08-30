import SwiftUI

struct AddIngredientSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PantryStore.self) private var pantry
    @State private var search = ""
    @State private var category: IngredientCategory?
    @State private var selected: IngredientDefinition?
    @State private var name = ""
    @State private var quantity = 1.0
    @State private var unit = "个"
    @State private var hasExpiry = false
    @State private var expiryDate = Calendar.current.date(byAdding: .day, value: 5, to: .now) ?? .now

    private let columns = [GridItem(.adaptive(minimum: 82), spacing: 10)]

    init(initialCategory: IngredientCategory? = nil) {
        _category = State(initialValue: initialCategory)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    searchAndCategories
                    quickGrid
                    entryForm
                }
                .padding(LuluLayout.gutter)
            }
            .background(LuluPalette.canvas.ignoresSafeArea())
            .navigationTitle(category == .seasoning ? "添加佐料" : "添加食材")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    pantry.add(
                        name: name,
                        category: selected?.category ?? category,
                        quantity: quantity,
                        unit: unit,
                        expiryDate: hasExpiry ? expiryDate : nil
                    )
                    dismiss()
                } label: {
                    Text(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "先选择或输入名称" : "加入我的冰箱")
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || quantity <= 0)
                .opacity(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1)
                .padding(.horizontal, LuluLayout.gutter)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
            }
        }
    }

    private var searchAndCategories: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("搜索食材或佐料……", text: $search)
                .textFieldStyle(.roundedBorder)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryChip(nil, title: "全部")
                    ForEach(IngredientCategory.allCases, id: \.self) { value in
                        categoryChip(value, title: value.rawValue)
                    }
                }
            }
        }
    }

    private var quickGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(IngredientCatalog.filtered(by: search, category: category)) { item in
                Button {
                    selected = item
                    name = item.name
                    unit = item.defaultUnit
                } label: {
                    VStack(spacing: 6) {
                        Text(item.emoji).font(.system(size: 30))
                        Text(item.name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(LuluPalette.ink)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 76)
                    .background(selected?.id == item.id ? LuluPalette.yellowSoft : LuluPalette.paper, in: RoundedRectangle(cornerRadius: 14))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(selected?.id == item.id ? LuluPalette.yellow : LuluPalette.line, lineWidth: selected?.id == item.id ? 2 : 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var entryForm: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(title: "确认记录", subtitle: "也可以直接输入自定义食材或佐料")
            TextField("名称", text: $name)
                .textFieldStyle(.roundedBorder)
                .onChange(of: name) { _, value in
                    if value != selected?.name { selected = nil }
                }

            HStack {
                Text("数量")
                Spacer()
                Stepper(value: $quantity, in: 0.5...999, step: quantity < 10 ? 0.5 : 10) {
                    Text(quantity.rounded() == quantity ? String(Int(quantity)) : String(format: "%.1f", quantity))
                        .fontWeight(.bold)
                }
                .fixedSize()
                TextField("单位", text: $unit)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 72)
            }
            Toggle("记录保质期", isOn: $hasExpiry)
            if hasExpiry {
                DatePicker("到期日", selection: $expiryDate, in: Calendar.current.startOfDay(for: .now)..., displayedComponents: .date)
            }
        }
        .font(.system(size: 14))
        .luluCard()
    }

    private func categoryChip(_ value: IngredientCategory?, title: String) -> some View {
        Button {
            category = value
        } label: {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(LuluPalette.ink)
                .padding(.horizontal, 13)
                .frame(height: 34)
                .background(category == value ? LuluPalette.yellow : LuluPalette.paper, in: Capsule())
                .overlay { Capsule().stroke(LuluPalette.line, lineWidth: 1) }
        }
        .buttonStyle(.plain)
    }
}

struct CameraComingSoonView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle().fill(LuluPalette.yellowSoft).frame(width: 130, height: 130)
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundStyle(LuluPalette.ink)
            }
            Text("逐个食材拍照识别")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            Text("入口和数据边界已经留好。下一版接入识别模型后，噜噜会先给出候选名称，再由你确认是否放进冰箱。")
                .font(.system(size: 14))
                .foregroundStyle(LuluPalette.sage)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 30)
            Label("现在请先使用手动添加", systemImage: "hand.tap.fill")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(LuluPalette.green)
            Spacer()
            Button("我知道了") { dismiss() }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, LuluLayout.gutter)
        }
        .padding(.vertical, 24)
        .background(LuluPalette.canvas.ignoresSafeArea())
    }
}
