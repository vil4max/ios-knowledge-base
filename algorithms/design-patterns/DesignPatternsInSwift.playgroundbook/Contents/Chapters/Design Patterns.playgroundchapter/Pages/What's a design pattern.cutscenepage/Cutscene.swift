import PlaygroundSupport
import SwiftUI

public extension Color {
    public static let guruRed = Color(red: 216.0/255.0, green: 55.0/255.0, blue: 63.0/255.0)
    public static let guruOrange = Color(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0)
    public static let guruLightOrange = Color(red: 248.0/255.0, green: 222.0/255.0, blue: 192.0/255.0)
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.guruLightOrange)
                .ignoresSafeArea()

            VStack(spacing: 36) {
                Image(uiImage: UIImage(named: "swift") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                VStack(spacing: 16) {
                    Text("What's a design pattern?")
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                    Text("**Design patterns** are typical solutions to commonly occurring problems in software design.")
                    Text("They are like pre-made blueprints that you can customize to solve a recurring design problem in your code.")
                }

                HStack {
                    Link(destination: URL(string: "https://refactoring.guru/design-patterns/creational-patterns")!, label: {
                        Label("Creational Design Patterns", systemImage: "link")
                    })
                    .buttonStyle(.borderedProminent)

                    Link(destination: URL(string: "https://refactoring.guru/design-patterns/structural-patterns")!, label: {
                        Label("Structural Design Patterns", systemImage: "link")
                    })
                    .buttonStyle(.borderedProminent)

                    Link(destination: URL(string: "https://refactoring.guru/design-patterns/behavioral-patterns")!, label: {
                        Label("Behavioral Design Patterns", systemImage: "link")
                    })
                    .buttonStyle(.borderedProminent)
                }
                .tint(Color.guruRed)
                .foregroundStyle(Color.guruLightOrange)
                .buttonStyle(.borderedProminent)

                Link(destination: URL(string: "https://refactoring.guru/design-patterns")!, label: {
                    Text("You can learn more about Design Patterns at Refactoring.Guru →")
                        .underline()
                })
                .fontWeight(.medium)

                Text("Open the chapters at the top-left and start reviewing the pattern examples.")
                    .font(.footnote)
            }
            .foregroundStyle(Color.guruOrange)
            .padding(.horizontal, 24)
        }
    }
}

let swiftUIView = ContentView()
let hostingController = UIHostingController(rootView: swiftUIView)

PlaygroundPage.current.liveView = hostingController
// [next page](@next)
