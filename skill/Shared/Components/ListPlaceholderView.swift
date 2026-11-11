import SwiftUI

struct ListPlaceholderView: View {
    let text: String
    let symbol: String

    var body: some View {
        Label(text, systemImage: symbol).foregroundStyle(.secondary)
    }
}

#Preview { ListPlaceholderView(text: "No Completed Activities Yet", symbol: "checkmark.circle") }
