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
        ZStack {
            PassportPaper()

            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ScrollView {
                        if stamps.isEmpty {
                            EmptyStateView(title: "No Stamps Yet", symbol: "book.closed",
                                           message: "Reach a skill’s activity goal to earn its stamp.")
                                .frame(minHeight: geometry.size.height)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 22) {
                                ForEach(Array(stamps.dropFirst(currentPage * 6).prefix(6))) { skill in
                                    PassportStampView(skill: skill)
                                        .frame(height: 190)
                                }
                            }
                            .padding(20)
                        }
                    }
                    .onTapGesture { location in
                        guard !stamps.isEmpty else { return }
                        page = min(max(0, currentPage + (location.x < geometry.size.width / 2 ? -1 : 1)), pageCount - 1)
                    }
                    .accessibilityAction(named: "Previous page") {
                        page = max(0, currentPage - 1)
                    }
                    .accessibilityAction(named: "Next page") {
                        page = min(pageCount - 1, currentPage + 1)
                    }
                }

                pageControls
            }
        }
        .task {
            skills.forEach { $0.assignStampStyle() }
        }
        .navigationTitle("Passport")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.accentTeal)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }

    private var pageControls: some View {
        HStack(spacing: 18) {
            Button {
                page = max(0, currentPage - 1)
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(currentPage == 0)
            .accessibilityLabel("Previous page")

            Text("Page \(currentPage + 1) of \(pageCount)")
                .font(.footnote.monospacedDigit())
                .foregroundStyle(Color.secondaryInk)
                .accessibilityLabel("Page \(currentPage + 1) of \(pageCount)")

            Button {
                page = min(pageCount - 1, currentPage + 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(currentPage >= pageCount - 1)
            .accessibilityLabel("Next page")
        }
        .font(.footnote.weight(.semibold))
        .foregroundStyle(Color.accentTeal)
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .glassEffect(.regular, in: .capsule)
        .padding(.bottom, 10)
    }
}

private struct PassportPaper: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.passportPaper, .passportPaperDeep],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(colors: [.white.opacity(0.35), .clear],
                           center: .topLeading, startRadius: 20, endRadius: 520)
            Circle()
                .strokeBorder(Color.ink.opacity(0.025), lineWidth: 26)
                .frame(width: 420, height: 420)
                .offset(x: 150, y: -240)
            Circle()
                .strokeBorder(Color.ink.opacity(0.02), lineWidth: 18)
                .frame(width: 320, height: 320)
                .offset(x: -170, y: 300)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        PassportView()
    }
    .modelContainer(previewContainer())
}
