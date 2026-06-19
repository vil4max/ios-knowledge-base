import PlaygroundSupport
import SwiftUI

public extension Color {
    public static let background = Color(red: 254.0/255.0, green: 245.0/255.0, blue: 212.0/255.0)
    public static let birdOrange = Color(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0)
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.background)
            
            VStack {
                ScrollView {
                    VStack(spacing: 36) {
                        VStack(spacing: 16) {
                            Image(uiImage: UIImage(named: "katabird") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            VStack(spacing: 4) {
                                Text("Swift Code Kata")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("コードカタ")
                                    .font(.headline)
                                    .fontWeight(.heavy)
                            }
                        }
                        .padding(.top, 128)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("first_paragraph")
                            Text("second_paragraph")
                        }
                        .frame(maxWidth: 720)
                        .padding(.horizontal, 24)
                    }
                    .foregroundStyle(Color.birdOrange)
                }
                
                Label("begin", systemImage: "sidebar.left")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.background)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity)
                    .background { Color.birdOrange }
            }
        }
        .ignoresSafeArea()
    }
}

let swiftUIView = ContentView()
let hostingController = UIHostingController(rootView: swiftUIView)

PlaygroundPage.current.liveView = hostingController
