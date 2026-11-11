import SwiftUI

struct LoadingView: View {
    let text: String

    var body: some View {
        HStack {
            ProgressView().progressViewStyle(.circular)
            Text(text)
        }
    }
}

#Preview { LoadingView(text: "Finding skills…") }
