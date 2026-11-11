import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var skills: [Skill]
    @State private var showingPassport = false

    var body: some View {
        List {
            LabeledContent("Stamps Collected", value: "\(skills.count)")
            Button("View Passport") {
                showingPassport = true
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
