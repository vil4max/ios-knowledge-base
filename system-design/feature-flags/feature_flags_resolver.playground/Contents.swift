import Foundation

/*
 Type-safe feature flag resolver — priority sources, snapshot lock, environment composition.

 Article: https://livsycode.com/best-practices/a-feature-flags-system-in-swift/
 Package: https://github.com/Livsy90/FeatureFlagsKit

 Run: builds a non-production stack, resolves flags, applies a local override, re-resolves.
*/

public protocol Feature: Sendable {
    var key: String { get }
    var description: String { get }
    var defaultValue: Bool { get }
}

public extension Feature where Self: RawRepresentable, RawValue == String {
    var key: String { rawValue }
    var description: String { rawValue }
}

public struct FeatureState<FeatureType: Feature>: Sendable {
    public let feature: FeatureType
    public let isEnabled: Bool

    public init(feature: FeatureType, isEnabled: Bool) {
        self.feature = feature
        self.isEnabled = isEnabled
    }
}

public func enable<FeatureType: Feature>(_ feature: FeatureType) -> FeatureState<FeatureType> {
    FeatureState(feature: feature, isEnabled: true)
}

public func disable<FeatureType: Feature>(_ feature: FeatureType) -> FeatureState<FeatureType> {
    FeatureState(feature: feature, isEnabled: false)
}

public enum FeatureFlagPriority: Int, Sendable, Comparable {
    case business = 0
    case testing = 100
    case simulator = 200
    case localOverrides = 300
    case forced = 400

    public static func < (lhs: FeatureFlagPriority, rhs: FeatureFlagPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

public protocol FeatureFlagSource: Sendable {
    var priority: FeatureFlagPriority { get }
    func value(forKey key: String) -> Bool?
}

public final class DictionaryFeatureFlagSource: FeatureFlagSource, @unchecked Sendable {
    public let priority: FeatureFlagPriority
    private var values: [String: Bool]

    public init(values: [String: Bool], priority: FeatureFlagPriority) {
        self.values = values
        self.priority = priority
    }

    public convenience init<FeatureType: Feature>(
        states: [FeatureState<FeatureType>],
        priority: FeatureFlagPriority
    ) {
        var values: [String: Bool] = [:]
        for state in states {
            values[state.feature.key] = state.isEnabled
        }
        self.init(values: values, priority: priority)
    }

    public func value(forKey key: String) -> Bool? {
        values[key]
    }
}

public final class PersistentOverrideFeatureFlagSource: FeatureFlagSource, @unchecked Sendable {
    public let priority: FeatureFlagPriority = .localOverrides
    private let defaults: UserDefaults
    private let storageKey: String
    private var values: [String: Bool]

    public init(
        defaults: UserDefaults = .standard,
        storageKey: String = "featureFlag.localOverrides"
    ) {
        self.defaults = defaults
        self.storageKey = storageKey
        self.values = defaults.dictionary(forKey: storageKey) as? [String: Bool] ?? [:]
    }

    public func value(forKey key: String) -> Bool? {
        values[key]
    }

    public func setOverride(_ isEnabled: Bool, forKey key: String) {
        values[key] = isEnabled
        defaults.set(values, forKey: storageKey)
    }

    public func setOverride<FeatureType: Feature>(_ isEnabled: Bool, for feature: FeatureType) {
        setOverride(isEnabled, forKey: feature.key)
    }

    public func clearOverride(forKey key: String) {
        values.removeValue(forKey: key)
        defaults.set(values, forKey: storageKey)
    }
}

public final class FeatureFlags: @unchecked Sendable {
    private let lock = NSLock()
    private var sources: [any FeatureFlagSource]

    public init(sources: [any FeatureFlagSource]) {
        self.sources = sources.sorted { $0.priority > $1.priority }
    }

    public func isEnabled<FeatureType: Feature>(_ feature: FeatureType) -> Bool {
        let snapshot = snapshotSources()
        for source in snapshot {
            if let value = source.value(forKey: feature.key) {
                return value
            }
        }
        return feature.defaultValue
    }

    private func snapshotSources() -> [any FeatureFlagSource] {
        lock.lock()
        defer { lock.unlock() }
        return sources
    }
}

@resultBuilder
public enum FeatureFlagBuilder {
    public static func buildBlock<FeatureType: Feature>(
        _ components: FeatureState<FeatureType>...
    ) -> [FeatureState<FeatureType>] {
        Array(components)
    }

    public static func buildOptional<FeatureType: Feature>(
        _ component: [FeatureState<FeatureType>]?
    ) -> [FeatureState<FeatureType>] {
        component ?? []
    }

    public static func buildEither<FeatureType: Feature>(
        first component: [FeatureState<FeatureType>]
    ) -> [FeatureState<FeatureType>] {
        component
    }

    public static func buildEither<FeatureType: Feature>(
        second component: [FeatureState<FeatureType>]
    ) -> [FeatureState<FeatureType>] {
        component
    }

    public static func buildArray<FeatureType: Feature>(
        _ components: [[FeatureState<FeatureType>]]
    ) -> [FeatureState<FeatureType>] {
        components.flatMap { $0 }
    }
}

public struct FlagConfiguration<FeatureType: Feature> {
    public let states: [FeatureState<FeatureType>]

    public init(@FeatureFlagBuilder _ content: () -> [FeatureState<FeatureType>]) {
        states = content()
    }
}

public enum FeatureFlagsEnvironment: Sendable {
    case production
    case nonProduction
}

public struct FeatureFlagsConfigurator<FeatureType: Feature> {
    public let environment: FeatureFlagsEnvironment
    public let isSimulator: Bool
    public let localOverridesSource: PersistentOverrideFeatureFlagSource?
    public let businessConfiguration: FlagConfiguration<FeatureType>?
    public let testingConfiguration: FlagConfiguration<FeatureType>?
    public let simulatorConfiguration: FlagConfiguration<FeatureType>?
    public let forcedConfiguration: FlagConfiguration<FeatureType>?

    public init(
        environment: FeatureFlagsEnvironment,
        isSimulator: Bool = false,
        localOverridesSource: PersistentOverrideFeatureFlagSource? = nil,
        businessConfiguration: FlagConfiguration<FeatureType>? = nil,
        testingConfiguration: FlagConfiguration<FeatureType>? = nil,
        simulatorConfiguration: FlagConfiguration<FeatureType>? = nil,
        forcedConfiguration: FlagConfiguration<FeatureType>? = nil
    ) {
        self.environment = environment
        self.isSimulator = isSimulator
        self.localOverridesSource = localOverridesSource
        self.businessConfiguration = businessConfiguration
        self.testingConfiguration = testingConfiguration
        self.simulatorConfiguration = simulatorConfiguration
        self.forcedConfiguration = forcedConfiguration
    }

    public func makeFeatureFlags() -> FeatureFlags {
        var sources: [any FeatureFlagSource] = []

        if let businessConfiguration {
            sources.append(
                DictionaryFeatureFlagSource(
                    states: businessConfiguration.states,
                    priority: .business
                )
            )
        }

        if environment == .nonProduction {
            if let testingConfiguration {
                sources.append(
                    DictionaryFeatureFlagSource(
                        states: testingConfiguration.states,
                        priority: .testing
                    )
                )
            }
            if isSimulator, let simulatorConfiguration {
                sources.append(
                    DictionaryFeatureFlagSource(
                        states: simulatorConfiguration.states,
                        priority: .simulator
                    )
                )
            }
            if let localOverridesSource {
                sources.append(localOverridesSource)
            }
            if let forcedConfiguration {
                sources.append(
                    DictionaryFeatureFlagSource(
                        states: forcedConfiguration.states,
                        priority: .forced
                    )
                )
            }
        }

        return FeatureFlags(sources: sources)
    }
}

enum AppFeature: String, CaseIterable, Feature {
    case newCheckout
    case debugMenu
    case verboseNetworking

    var defaultValue: Bool {
        switch self {
        case .newCheckout: false
        case .debugMenu: false
        case .verboseNetworking: false
        }
    }
}

let playgroundDefaults = UserDefaults(suiteName: "feature-flags-playground")!
playgroundDefaults.removePersistentDomain(forName: "feature-flags-playground")

let overrideSource = PersistentOverrideFeatureFlagSource(
    defaults: playgroundDefaults,
    storageKey: "overrides"
)

let businessConfig = FlagConfiguration<AppFeature> {
    disable(AppFeature.newCheckout)
}

let testingConfig = FlagConfiguration<AppFeature> {
    enable(AppFeature.newCheckout)
    enable(AppFeature.debugMenu)
}

let flags = FeatureFlagsConfigurator<AppFeature>(
    environment: .nonProduction,
    localOverridesSource: overrideSource,
    businessConfiguration: businessConfig,
    testingConfiguration: testingConfig
).makeFeatureFlags()

func printResolution(_ label: String) {
    print("--- \(label) ---")
    for feature in AppFeature.allCases {
        print("  \(feature.rawValue): \(flags.isEnabled(feature))")
    }
}

printResolution("After testing config wins over business")
overrideSource.setOverride(false, for: AppFeature.newCheckout)
printResolution("Local override disables newCheckout")
overrideSource.clearOverride(forKey: AppFeature.newCheckout.key)
printResolution("Override cleared — testing config applies again")
