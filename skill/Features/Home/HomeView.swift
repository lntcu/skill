import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var showingPassport = false

    var body: some View {
        List {
            Section("Passport") {
                LabeledContent("Stamps Collected", value: "\(skills.filter(\.isMastered).count)")
                Button("View Passport") { showingPassport = true }
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
        .navigationTitle("Home")
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
