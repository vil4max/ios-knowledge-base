import PlaygroundSupport
import SwiftUI

extension View {
    func floatingSafeAreaBar<InsetContent: View>(
        @ViewBuilder insetContent: @escaping () -> InsetContent
    ) -> some View {
        modifier(FloatingSafeAreaBar(insetContent: insetContent))
    }
}

struct FloatingSafeAreaBar<InsetContent: View>: ViewModifier {
    @ViewBuilder let insetContent: () -> InsetContent

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content.safeAreaBar(edge: .bottom) {
                insetContent()
                    .modifier(CardStyle())
            }
        } else {
            content.safeAreaInset(edge: .bottom) {
                insetContent()
                    .modifier(CardStyle())
                    .background {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                VStack(spacing: 0) {
                                    LinearGradient(
                                        colors: [.clear, .black],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .frame(height: 30)
                                    Color.black
                                }
                            )
                            .ignoresSafeArea()
                    }
            }
        }
    }
}

private struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray.opacity(0.25), lineWidth: 1))
            .shadow(color: .black.opacity(0.1), radius: 5)
            .padding()
    }
}

struct FloatingSafeAreaBarDemo: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<50, id: \.self) { index in
                    Text("Row \(index)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
        }
        .floatingSafeAreaBar {
            VStack(spacing: 12) {
                Text("Some summary content")
                Button("Save") { }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

PlaygroundPage.current.setLiveView(FloatingSafeAreaBarDemo())
