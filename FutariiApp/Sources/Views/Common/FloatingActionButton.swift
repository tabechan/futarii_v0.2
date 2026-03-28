import SwiftUI

struct FloatingActionButton: View {
    @Binding var showModal: Bool
    
    var body: some View {
        Button(action: {
            showModal = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.appAccent)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
        }
    }
}
