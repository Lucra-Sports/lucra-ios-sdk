import Foundation
import Sentry
@_spi(LucraTelemetry) import LucraSDK

enum SentryScrubbers {
    static func scrub(_ event: Sentry.Event) -> Sentry.Event {
        if let message = event.message {
            let scrubbed = SentryMessage(formatted: TelemetryRedactor.scrubText(message.formatted) ?? message.formatted)
            scrubbed.message = TelemetryRedactor.scrubText(message.message)
            scrubbed.params = message.params?.compactMap { TelemetryRedactor.scrubText($0) }
            event.message = scrubbed
        }

        event.exceptions?.forEach { $0.value = TelemetryRedactor.scrubText($0.value) ?? $0.value }

        if let extra = event.extra {
            event.extra = TelemetryRedactor.scrubDictionary(extra)
        }
        if let tags = event.tags {
            event.tags = tags.mapValues { TelemetryRedactor.scrubText($0) ?? $0 }
        }
        event.breadcrumbs?.forEach { scrub($0) }

        if let request = event.request {
            request.headers = TelemetryRedactor.filterHeaders(request.headers)
            request.queryString = nil
            request.cookies = nil
        }
        return event
    }

    @discardableResult
    static func scrub(_ breadcrumb: Sentry.Breadcrumb) -> Sentry.Breadcrumb {
        breadcrumb.message = TelemetryRedactor.scrubText(breadcrumb.message)
        if let data = breadcrumb.data {
            breadcrumb.data = TelemetryRedactor.scrubDictionary(data)
        }
        return breadcrumb
    }
}
