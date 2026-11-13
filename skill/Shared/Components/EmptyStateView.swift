import SwiftUI

struct EmptyStateView: View {
    let title: String
    let symbol: String
    var message: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color.accentTeal)
            Text(title).font(.headline)
            if !message.isEmpty { Text(message).foregroundStyle(.secondary) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview { EmptyStateView(title: "No Stamps Yet", symbol: "book.closed") }
