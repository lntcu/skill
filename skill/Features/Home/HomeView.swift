import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var showingPassport = false

    private var stampCount: Int { skills.filter(\.isMastered).count }

    var body: some View {
        List {
            Section {
                LabeledContent {
                    Text("\(stampCount)")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(stampCount == 0 ? Color.secondaryInk : Color.coral)
                        .contentTransition(.numericText())
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.gold)
                        Text("Stamps Collected")
                    }
                }
                Button("View Passport") { showingPassport = true }
            } header: {
                Text("Passport")
            }
            Section {
                IslandMapView(skills: skills)
                    .frame(height: skills.isEmpty ? 50 : 460)
                    .listRowInsets(EdgeInsets())
            } header: {
                Text("Your Islands")
            } footer: {
                Text("Drag to explore, pinch or double-tap to zoom. Tap an island to visit its skill. Complete its goal to fully unlock it.")
            }
        }
        .appScreenBackground()
        .navigationTitle("Home")
        .tint(.accentTeal)
        .sheet(isPresented: $showingPassport) {
            NavigationStack {
                PassportView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(previewContainer())
}
