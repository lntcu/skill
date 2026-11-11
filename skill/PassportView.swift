import SwiftUI
import SwiftData

struct PassportView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var page = 0

    private var pageCount: Int { max(1, (skills.count + 5) / 6) }
    private var currentPage: Int { min(page, pageCount - 1) }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    if skills.isEmpty {
                        ContentUnavailableView("No Stamps Yet", systemImage: "book.closed",
                                               description: Text("Each skill adds a stamp to your passport."))
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            ForEach(Array(skills.dropFirst(currentPage * 6).prefix(6))) { skill in
                                VStack(spacing: 8) {
                                    Image(systemName: "seal")
                                        .font(.largeTitle)
                                    Text(skill.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                }
                                .foregroundStyle(Color(hue: skill.stampHue ?? 0.5, saturation: 0.65, brightness: 0.7))
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .padding(8)
                                .rotationEffect(.degrees(skill.stampRotation))
                                .offset(x: skill.stampOffset, y: skill.stampOffset)
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
