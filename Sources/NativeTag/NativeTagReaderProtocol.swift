//
//  NativeTagReaderProtocol.swift
//  NativeTag
//
//  Created by treastrain on 2023/05/05.
//

public protocol NativeTagReaderProtocol {
    associatedtype ReaderProtocol
    init()
    func read(
        taskPriority: TaskPriority?,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void,
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void,
        didDetect: @escaping @Sendable (_ reader: ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) async throws
    func invalidate() async
}
