import SwiftUI
import SwiftData

struct PassportView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var page = 0

    private var stamps: [Skill] { skills.filter(\.isMastered) }

    private var pageCount: Int { max(1, (stamps.count + 5) / 6) }
    private var currentPage: Int { min(page, pageCount - 1) }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    if stamps.isEmpty {
                        EmptyStateView(title: "No Stamps Yet", symbol: "book.closed",
                                       message: "Reach a skill’s activity goal to earn its stamp.")
                            .frame(minHeight: geometry.size.height)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            ForEach(Array(stamps.dropFirst(currentPage * 6).prefix(6))) { skill in
                                PassportStampView(skill: skill)
                                    .frame(height: 200)
                            }
                        }
                        .padding()
                    }
                }
                .onTapGesture { location in
                    page = min(max(0, currentPage + (location.x < geometry.size.width / 2 ? -1 : 1)), pageCount - 1)
                }
                .accessibilityAction(named: "Previous page") {
                    page = max(0, currentPage - 1)
                }
                .accessibilityAction(named: "Next page") {
                    page = min(pageCount - 1, currentPage + 1)
                }
            }
            Text("\(currentPage + 1) / \(pageCount)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom)
                .accessibilityLabel("Page \(currentPage + 1) of \(pageCount)")
        }
        .task {
            skills.forEach { $0.assignStampStyle() }
        }
        .navigationTitle("Passport")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PassportView()
    }
    .modelContainer(previewContainer())
}
