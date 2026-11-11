import SwiftUI

extension View {
    func bottomActionStyle() -> some View {
        self.buttonStyle(.glass)
            .controlSize(.large)
            .tint(.black)
            .frame(maxWidth: .infinity)
            .padding()
    }
}
