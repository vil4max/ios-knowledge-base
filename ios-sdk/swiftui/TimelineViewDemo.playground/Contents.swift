import PlaygroundSupport
import SwiftUI

struct MinuteClockView: View {
    var body: some View {
        TimelineView(.everyMinute) { context in
            Text(context.date, format: .dateTime.hour().minute())
                .font(.title2.monospacedDigit())
        }
    }
}

struct SecondClockView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            Text(context.date, format: .dateTime.hour().minute().second())
                .font(.title2.monospacedDigit())
        }
    }
}

struct CadenceAwareClockView: View {
    var body: some View {
        TimelineView(.animation) { context in
            let format: Date.FormatStyle =
                context.cadence == .live
                ? .dateTime.hour().minute().second().secondFraction(.fractional(3))
                : .dateTime.hour().minute().second()

            let cadenceLabel: String = {
                switch context.cadence {
                case .live:
                    return "live"
                case .seconds:
                    return "seconds"
                case .minutes:
                    return "minutes"
                @unknown default:
                    return "other"
                }
            }()

            VStack(alignment: .leading, spacing: 4) {
                Text(context.date, format: format)
                    .font(.title3.monospacedDigit())
                Text("cadence: \(cadenceLabel)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct AnimatedHueBackground: View {
    var body: some View {
        TimelineView(.animation) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            let hue = (sin(time * 0.2) + 1) / 2

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hue: hue, saturation: 0.7, brightness: 0.9))
                .frame(height: 56)
                .overlay {
                    Text("animation schedule")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.9))
                }
        }
    }
}

struct TimelineViewDemo: View {
    var body: some View {
        NavigationStack {
            List {
                Section("everyMinute") {
                    MinuteClockView()
                }
                Section("periodic(from:by: 1)") {
                    SecondClockView()
                }
                Section("cadence") {
                    CadenceAwareClockView()
                }
                Section("animation") {
                    AnimatedHueBackground()
                }
            }
            .navigationTitle("TimelineView")
        }
    }
}

PlaygroundPage.current.setLiveView(TimelineViewDemo())
