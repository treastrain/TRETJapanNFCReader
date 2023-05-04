//
//  SwiftUIView+.swift
//  ISO15693
//
//  Created by treastrain on 2023/01/26.
//

#if canImport(CoreNFC) && canImport(SwiftUI)
import SwiftUI

extension View {
    public func iso15693TagReader(
        isPresented: Binding<Bool>,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: ISO15693TagReader.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) -> some View {
        modifier(
            NativeTagReaderViewModifier<ISO15693TagReader>(
                isPresented: isPresented,
                taskPriority: taskPriority,
                detectingAlertMessage: detectingAlertMessage,
                onBeginReadingError: onBeginReadingError,
                didBecomeActive: didBecomeActive,
                didInvalidate: didInvalidate,
                didDetect: didDetect
            )
        )
    }
}
#endif
