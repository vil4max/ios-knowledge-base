import SwiftUI

struct EmptyContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Image(systemName: "app.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 4)
                
                Image(systemName: "swift")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.42, blue: 0.0),   // #FF6C00
                                Color(red: 1.0, green: 0.62, blue: 0.04)   // #FF9F0A
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(9)
            }
            .frame(width: 60, height: 60)
            
            Text("Assets for Playgrounds")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("A practical resource designed to enrich your Swift Playground projects.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .ignoresSafeArea(.all)
    }
}

#Preview {
    EmptyContentView()
}
