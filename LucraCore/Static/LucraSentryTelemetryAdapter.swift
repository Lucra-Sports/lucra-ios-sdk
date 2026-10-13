import Foundation
@_spi(LucraTelemetry) import LucraSDK

@objc(LucraSentryTelemetryAdapter)
final class LucraSentryTelemetryAdapter: NSObject, LucraTelemetryAdapter {
    override init() {
        super.init()
    }

    func makeSink(context: LucraTelemetryContext) -> TelemetrySink? {
        SentryTelemetryService.start(context: context)
    }
}
