import SwiftUI

extension View {
    func bottomActionStyle() -> some View {
        self.buttonStyle(.glass)
            .controlSize(.large)
            .tint(.ink)
            .frame(maxWidth: .infinity)
            .padding()
    }
}
