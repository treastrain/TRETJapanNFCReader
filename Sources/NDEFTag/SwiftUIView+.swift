//
//  SwiftUIView+.swift
//  NDEFTag
//
//  Created by treastrain on 2023/01/22.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import SwiftUI

extension View {
    public func nfcNDEFTagReader(
        isPresented: Binding<Bool>,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NDEFTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @escaping @Sendable (_ reader: NDEFTag.ReaderProtocol, _ tags: NDEFTag.ReaderDetectObject) async throws -> NDEFTag.DetectResult
    ) -> some View {
        modifier(
            NFCReader<NDEFTag>.ViewModifier(
                isPresented: isPresented,
                reader: NFCReader<NDEFTag>(),
                taskPriority: taskPriority,
                onBeginReadingError: onBeginReadingError,
                read: { reader, didInvalidateHandler in
                    try await reader.read(
                        taskPriority: taskPriority,
                        detectingAlertMessage: detectingAlertMessage,
                        didBecomeActive: didBecomeActive,
                        didInvalidate: {
                            didInvalidateHandler()
                            didInvalidate($0)
                        },
                        didDetect: didDetectNDEFs
                    )
                }
            )
        )
    }
}
#endif
