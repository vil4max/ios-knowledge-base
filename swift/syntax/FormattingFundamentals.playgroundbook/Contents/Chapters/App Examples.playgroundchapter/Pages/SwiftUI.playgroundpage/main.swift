import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    let weight = Measurement(value: 1.5, unit: UnitMass.kilograms)
    let price = 149.99

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(uiImage: UIImage(named: "backpack.jpeg")!)
                
                Text("""
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                """)
                
                HStack {
                    Spacer()
                    Image(systemName: "scalemass.fill")
                        .foregroundStyle(.blue)
                    Spacer()
                    Text(weight, formatter: MeasurementFormatter())
                        .frame(width: 100)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Image(systemName: "dollarsign.circle")
                        .foregroundStyle(.blue)
                    Spacer()
                    Text(price, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .frame(width: 100)
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("SwiftUI Example")
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
