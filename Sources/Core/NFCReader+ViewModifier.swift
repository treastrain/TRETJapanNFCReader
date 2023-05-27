//
//  NFCReader+ViewModifier.swift
//  Core
//
//  Created by treastrain on 2023/05/05.
//

#if canImport(CoreNFC) && canImport(SwiftUI)
import Combine
import SwiftUI

extension NFCReader {
    public struct ViewModifier {
        private var isPresented: Binding<Bool>
        private let reader: @Sendable () -> NFCReader<TagType>
        private let taskPriority: TaskPriority?
        private let onBeginReadingError: @Sendable (Error) -> Void
        private let read: @Sendable (NFCReader<TagType>, @escaping () -> Void) async throws -> Void
        
        private let object = Object()
        
        public init(
            isPresented: Binding<Bool>,
            reader: @autoclosure @escaping @Sendable () -> NFCReader<TagType>,
            taskPriority: TaskPriority? = nil,
            onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void,
            read: @escaping @Sendable (_ reader: NFCReader<TagType>, _ didInvalidate: @escaping () -> Void) async throws -> Void
        ) {
            self.isPresented = isPresented
            self.reader = reader
            self.taskPriority = taskPriority
            self.onBeginReadingError = onBeginReadingError
            self.read = read
        }
    }
}

extension NFCReader.ViewModifier {
    private final class Object {
        private var currentTask: Task<(), Never>?
        private var reader: NFCReader<TagType>?
        
        func read(
            with reader: NFCReader<TagType>,
            taskPriority: TaskPriority?,
            onBeginReadingError: @escaping @Sendable (Error) -> Void,
            read: @escaping @Sendable (NFCReader<TagType>) async throws -> Void
        ) {
            cancel()
            currentTask = Task(priority: taskPriority) {
                await withTaskCancellationHandler {
                    self.reader = reader
                    do {
                        try await read(self.reader!)
                    } catch {
                        onBeginReadingError(error)
                        self.reader = nil
                    }
                } onCancel: {
                    self.reader = nil
                }
            }
        }
        
        func cancel() {
            Task { [reader] in
                await reader?.invalidate()
            }
            currentTask?.cancel()
            currentTask = nil
            reader = nil
        }
    }
}

extension NFCReader.ViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .onChange(of: isPresented.wrappedValue, perform: action(_:))
        } else {
            content
                .onReceive(Just(isPresented.wrappedValue), perform: action(_:))
        }
    }
    
    private func action(_ flag: Bool) {
        if flag {
            object.read(
                with: reader(),
                taskPriority: taskPriority,
                onBeginReadingError: {
                    isPresented.wrappedValue = false
                    onBeginReadingError($0)
                },
                read: {
                    try await read($0) {
                        isPresented.wrappedValue = false
                        object.cancel()
                    }
                }
            )
        } else {
            object.cancel()
        }
    }
}
#endif
