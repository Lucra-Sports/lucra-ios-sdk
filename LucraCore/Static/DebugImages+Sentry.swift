import Foundation
import Sentry
@_spi(LucraTelemetry) import LucraSDK

extension DebugImages {
    static func attach(to event: Sentry.Event) {
        if let existing = event.debugMeta, !existing.isEmpty { return }

        var stacktraces = (event.threads ?? []).compactMap { $0.stacktrace }
        stacktraces += (event.exceptions ?? []).compactMap { $0.stacktrace }
        if let own = event.stacktrace { stacktraces.append(own) }
        let frames = stacktraces.flatMap { $0.frames }
        let imageAddresses = Set(frames.compactMap { $0.imageAddress.flatMap(parseHex) })
        let instructionAddresses = frames.compactMap { $0.instructionAddress.flatMap(parseHex) }
        guard !imageAddresses.isEmpty || !instructionAddresses.isEmpty else { return }

        let selected = LoadedImages.select(LoadedImages.current(), imageAddresses: imageAddresses, instructionAddresses: instructionAddresses)
        guard !selected.isEmpty else { return }
        event.debugMeta = selected.map { image in
            let meta = Sentry.DebugMeta()
            meta.type = "macho"
            meta.debugID = image.uuid
            meta.imageAddress = hex(image.address)
            meta.imageVmAddress = hex(image.vmAddress)
            meta.imageSize = NSNumber(value: image.size)
            meta.codeFile = image.path
            return meta
        }
    }
}
