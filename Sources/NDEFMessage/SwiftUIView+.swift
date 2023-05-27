//
//  SwiftUIView+.swift
//  NDEFMessage
//
//  Created by treastrain on 2023/01/22.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import SwiftUI

extension View {
    public func nfcNDEFMessageReader(
        isPresented: Binding<Bool>,
        taskPriority: TaskPriority? = nil,
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NDEFMessage.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @escaping @Sendable (_ reader: NDEFMessage.ReaderProtocol, _ messages: NDEFMessage.ReaderDetectObject) async -> NDEFMessage.DetectResult
    ) -> some View {
        modifier(
            NFCReader<NDEFMessage>.ViewModifier(
                isPresented: isPresented,
                reader: NFCReader<NDEFMessage>(),
                taskPriority: taskPriority,
                onBeginReadingError: onBeginReadingError,
                read: { reader, didInvalidateHandler in
                    try await reader.read(
                        taskPriority: taskPriority,
                        invalidateAfterFirstRead: invalidateAfterFirstRead,
                        detectingAlertMessage: detectingAlertMessage,
                        didBecomeActive: didBecomeActive,
                        didInvalidate: {
                            didInvalidateHandler()
                            didInvalidate($0)
                        },
                        didDetectNDEFs: didDetectNDEFs
                    )
                }
            )
        )
    }
}
#endif
