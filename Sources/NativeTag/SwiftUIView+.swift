//
//  SwiftUIView+.swift
//  NativeTag
//
//  Created by treastrain on 2023/01/23.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import SwiftUI

extension View {
    public func nfcNativeTagReader(
        isPresented: Binding<Bool>,
        pollingOption: NFCTagReaderSession.PollingOption,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: NativeTag.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) -> some View {
        modifier(
            NFCReader<NativeTag>.ViewModifier(
                isPresented: isPresented,
                reader: NFCReader<NativeTag>(),
                taskPriority: taskPriority,
                onBeginReadingError: onBeginReadingError,
                read: { reader, didInvalidateHandler in
                    try await reader.read(
                        pollingOption: pollingOption,
                        taskPriority: taskPriority,
                        detectingAlertMessage: detectingAlertMessage,
                        didBecomeActive: didBecomeActive,
                        didInvalidate: {
                            didInvalidateHandler()
                            didInvalidate($0)
                        },
                        didDetect: didDetect
                    )
                }
            )
        )
    }
}
#endif
