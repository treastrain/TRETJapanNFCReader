//
//  NativeTag+ReaderViewModifier.swift
//  NativeTag
//
//  Created by treastrain on 2023/05/04.
//

#if canImport(CoreNFC) && canImport(SwiftUI)
import Combine
import SwiftUI

extension NativeTag {
    public struct ReaderViewModifier<Reader: NativeTagReaderProtocol> {
        private typealias Source = NFCReader<NativeTag>
        private let viewModifier: Source.ViewModifier
        
        public init(
            isPresented: Binding<Bool>,
            taskPriority: TaskPriority? = nil,
            detectingAlertMessage: String,
            onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
            didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
            didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
            didDetect: @escaping @Sendable (_ reader: Reader.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
        ) {
            self.viewModifier = .init(
                isPresented: isPresented,
                reader: Reader() as! Source,
                taskPriority: taskPriority,
                onBeginReadingError: onBeginReadingError,
                read: { reader, didInvalidateHandler in
                    try await (reader as! Reader).read(
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
        }
    }
}

extension NativeTag.ReaderViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.modifier(viewModifier)
    }
}
#endif
