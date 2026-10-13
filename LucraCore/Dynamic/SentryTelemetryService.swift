import Foundation
import Sentry
@_spi(LucraTelemetry) import LucraSDK

final class SentryTelemetryService: TelemetrySink {
    private static let maxBreadcrumbs = 150

    private let hubLock = NSLock()
    private var storedHub: SentryHub?
    private var hub: SentryHub? {
        get { hubLock.lock(); defer { hubLock.unlock() }; return storedHub }
        set { hubLock.lock(); defer { hubLock.unlock() }; storedHub = newValue }
    }

    static func start(context: LucraTelemetryContext) -> TelemetrySink? {
        var dsn = context.dsn
        let override = ProcessInfo.processInfo.environment["LUCRA_TELEMETRY_DSN"] ?? ""
        guard override != "off" else { return nil }
        #if DEBUG
        if !override.isEmpty {
            dsn = override
        }
        #endif
        guard !dsn.isEmpty else { return nil }

        let options = Sentry.Options()
        options.dsn = dsn
        options.environment = context.environment
        options.releaseName = "LucraSDK@\(context.sdkVersion)"
        options.enableCrashHandler = false
        options.enableAutoSessionTracking = false
        options.enableSwizzling = false
        options.enableAutoPerformanceTracing = false
        options.enableCaptureFailedRequests = false
        options.enableNetworkBreadcrumbs = false
        options.enableAppHangTracking = false
        options.enableWatchdogTerminationTracking = false
        options.sendDefaultPii = false
        options.attachStacktrace = true
        options.maxBreadcrumbs = UInt(maxBreadcrumbs)
        options.beforeSend = { event in
            DebugImages.attach(to: event)
            return SentryScrubbers.scrub(event)
        }
        options.beforeBreadcrumb = { SentryScrubbers.scrub($0) }

        guard let client = SentryClient(options: options) else { return nil }

        let scope = Sentry.Scope(maxBreadcrumbs: maxBreadcrumbs)
        scope.setTag(value: context.sdkVersion, key: "sdk_version")
        scope.setTag(value: context.hostBundleIdentifier, key: "host_bundle_id")
        scope.setTag(value: context.hostVersion, key: "host_version")

        let service = SentryTelemetryService()
        service.hub = SentryHub(client: client, andScope: scope)
        return service
    }

    func release() {
        guard let client = hub?.getClient() else { hub = nil; return }
        hub = nil
        DispatchQueue.global(qos: .utility).async {
            client.flush(timeout: 2)
            client.close()
        }
    }

    func breadcrumb(_ message: String, category: String, level: TelemetryLevel) {
        guard let hub else { return }
        hub.add(makeBreadcrumb(message, category: category, level: level.sentryLevel))
    }

    func nonFatal(_ message: String, category: String, file: String, function: String, line: Int, error: Error?) {
        guard let hub else { return }
        hub.add(makeBreadcrumb(message, category: category, level: .error))
        guard TelemetryErrorFilter.shouldReport(error) else { return }

        let scope = Sentry.Scope(scope: hub.scope)
        scope.setTag(value: category, key: "lucra.category")
        scope.setTag(value: (file as NSString).lastPathComponent, key: "lucra.file")
        scope.setTag(value: function, key: "lucra.function")
        scope.setTag(value: String(line), key: "lucra.line")
        scope.setExtra(value: message, key: "lucra.message")
        if let error {
            hub.capture(error: error, scope: scope)
        } else {
            let event = Sentry.Event(level: .error)
            event.message = SentryMessage(formatted: message)
            hub.capture(event: event, scope: scope)
        }
    }

    func setUser(id: String?) {
        hub?.configureScope { scope in
            scope.setUser(id.map { Sentry.User(userId: $0) })
        }
    }

    func network(_ breadcrumb: NetworkBreadcrumb) {
        guard let hub else { return }
        let crumb = Sentry.Breadcrumb(level: breadcrumb.level.sentryLevel, category: "http")
        crumb.type = "http"
        crumb.data = breadcrumb.data
        hub.add(crumb)
    }

    private func makeBreadcrumb(_ message: String, category: String, level: SentryLevel) -> Sentry.Breadcrumb {
        let crumb = Sentry.Breadcrumb(level: level, category: category)
        crumb.message = message
        return crumb
    }
}

private extension TelemetryLevel {
    var sentryLevel: SentryLevel {
        switch self {
        case .info: return .info
        case .warning: return .warning
        case .error: return .error
        }
    }
}
