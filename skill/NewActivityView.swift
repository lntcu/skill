import SwiftUI

struct NewActivityView: View {
    @State private var energy = "Okay"
    @State private var minutes = 30

    var body: some View {
        Form {
            Picker("Energy Level", selection: $energy) {
                ForEach(["Tired", "Low", "Okay", "Energetic", "Very Energetic"], id: \.self) {
                    Text($0)
                }
            }
            Section("Time Available") {
                Stepper("\(minutes) minutes", value: $minutes, in: 5...240, step: 5)
            }
        }
        .navigationTitle("New Activity")
        .safeAreaInset(edge: .bottom) {
            Button("Next", action: {})
                .buttonStyle(.borderedProminent)
                .disabled(true)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.bar)
        }
    }
}

#Preview {
    NavigationStack {
        NewActivityView()
    }
}
