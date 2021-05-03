//
//  ReaderError.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/28.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public let ErrorDomain: String = "TRETNFCKitError"

/// Key in NSError userInfo dictionary.  The corresponding value is the NSUInteger error code from tag's response. Refer to ISO15693 specification for the error code values.
public let ISO15693TagResponseErrorKey: String = "ISO15693TagResponseErrorCode"

/// Key in NSError userInfo dictionary.  Presence of this key indicates the received response packet length is invalid.
public let TagResponseUnexpectedLengthErrorKey: String = "TagResponseInvalidLength"

/// Possible errors returned by NFCKit and CoreNFC framework reader session.
public struct ReaderError: Error, LocalizedError, CustomNSError {
    public enum Code: Int, CaseIterable {
        /// The reader session does not support this feature.
        case readerErrorUnsupportedFeature = 1
        /// A security violation associated with the reader session has occurred.
        case readerErrorSecurityViolation = 2
        /// An input parameter is invalid.
        case readerErrorInvalidParameter = 3
        /// The length of an input parameter is invalid.
        case readerErrorInvalidParameterLength = 4
        /// A parameter value is outside of the acceptable boundary.
        case readerErrorParameterOutOfBound = 5
        /// The NFC wireless radio on the device is disabled.
        case readerErrorRadioDisabled = 6
        /// The reader lost the connection to the tag.
        case readerTransceiveErrorTagConnectionLost = 100
        /// Too many retries have occurred.
        case readerTransceiveErrorRetryExceeded = 101
        /// The tag has responded with an error.
        case readerTransceiveErrorTagResponseError = 102
        /// The reader session is invalid.
        case readerTransceiveErrorSessionInvalidated = 103
        /// The tag isn’t in the connected state.
        case readerTransceiveErrorTagNotConnected = 104
        /// The packet length exceeds the limit supported by the tag.
        case readerTransceiveErrorPacketTooLong = 105
        /// The user canceled the reader session.
        case readerSessionInvalidationErrorUserCanceled = 200
        /// The reader session timed out.
        case readerSessionInvalidationErrorSessionTimeout = 201
        /// The reader session terminated unexpectedly.
        case readerSessionInvalidationErrorSessionTerminatedUnexpectedly = 202
        /// The reader session failed because the system is busy.
        case readerSessionInvalidationErrorSystemIsBusy = 203
        /// The first NDEF tag read by this session is invalid.
        case readerSessionInvalidationErrorFirstNDEFTagRead = 204
        /// The tag has been configured with invalid parameters.
        case tagCommandConfigurationErrorInvalidParameters = 300
        /// The NDEF tag isn’t writable.
        case ndefReaderSessionErrorTagNotWritable = 400
        /// The reader session failed to update the NDEF tag.
        case ndefReaderSessionErrorTagUpdateFailure = 401
        /// The NDEF tag memory size is too small to store the data.
        case ndefReaderSessionErrorTagSizeTooSmall = 402
        /// The NDEF tag doesn’t contain an NDEF message.
        case ndefReaderSessionErrorZeroLengthMessage = 403
        
        case kitErrorCoreNFCAndNFCKitErrorCodeConversionFailed = 999999999
    }
    
    /// Initialize an error within this domain with the given code and userInfo.
    public init(_ code: Code, userInfo: [String : Any] = [:], description: String? = nil) {
        self.code = code
        self.errorCode = code.rawValue
        self.errorUserInfo = userInfo
        self.errorDescription = description
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 11.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCReaderError) {
        self.code = Code(rawValue: coreNFCInstance.code.rawValue) ?? .kitErrorCoreNFCAndNFCKitErrorCodeConversionFailed
        self.errorCode = coreNFCInstance.errorCode
        self.errorUserInfo = coreNFCInstance.errorUserInfo
        self.errorDescription = coreNFCInstance.localizedDescription
    }
    #endif
    
    /// NFCKit is not supported on the current platform.
    public static var readerErrorUnsupportedFeature: Code = .readerErrorUnsupportedFeature
    /// Missing required entitlement and/or privacy settings from the client app.
    public static var readerErrorSecurityViolation: Code = .readerErrorSecurityViolation
    /// Input parameter is invalid.
    public static var readerErrorInvalidParameter: Code = .readerErrorInvalidParameter
    /// Length of input parameter is invalid, i.e. size of data container.
    public static var readerErrorInvalidParameterLength: Code = .readerErrorInvalidParameterLength
    /// Parameter value is outside of the acceptable boundary / range.
    public static var readerErrorParameterOutOfBound: Code = .readerErrorParameterOutOfBound
    /// NFC Radio is disabled.
    public static var readerErrorRadioDisabled: Code = .readerErrorRadioDisabled
    /// Connection to the tag is lost.
    public static var readerTransceiveErrorTagConnectionLost: Code = .readerTransceiveErrorTagConnectionLost
    /// Maximum data transmission retry has reached.
    public static var readerTransceiveErrorRetryExceeded: Code = .readerTransceiveErrorRetryExceeded
    /// Tag response is invalid or tag does not provide a response.  Additional error information may be contain in the underlying user info dictionary.
    public static var readerTransceiveErrorTagResponseError: Code = .readerTransceiveErrorTagResponseError
    /// Session has been previously invalidated.
    public static var readerTransceiveErrorSessionInvalidated: Code = .readerTransceiveErrorSessionInvalidated
    /// Packet length has exceeded the limit.
    public static var readerTransceiveErrorPacketTooLong: Code = .readerTransceiveErrorPacketTooLong
    /// Tag is not in the connected state.
    public static var readerTransceiveErrorTagNotConnected: Code = .readerTransceiveErrorTagNotConnected
    /// Session is invalidated by the user.
    public static var readerSessionInvalidationErrorUserCanceled: Code = .readerSessionInvalidationErrorUserCanceled
    /// Session is timed out.
    public static var readerSessionInvalidationErrorSessionTimeout: Code = .readerSessionInvalidationErrorSessionTimeout
    /// Session is terminated unexpectly.
    public static var readerSessionInvalidationErrorSessionTerminatedUnexpectedly: Code = .readerSessionInvalidationErrorSessionTerminatedUnexpectedly
    /// Core NFC is temporary unavailable due to system resource constraints.
    public static var readerSessionInvalidationErrorSystemIsBusy: Code = .readerSessionInvalidationErrorSystemIsBusy
    /// Session is terminated after the 1st NDEF tag is read.
    public static var readerSessionInvalidationErrorFirstNDEFTagRead: Code = .readerSessionInvalidationErrorFirstNDEFTagRead
    public static var tagCommandConfigurationErrorInvalidParameters: Code = .tagCommandConfigurationErrorInvalidParameters
    /// NDEF tag is not writable.
    public static var ndefReaderSessionErrorTagNotWritable: Code = .ndefReaderSessionErrorTagNotWritable
    /// NDEF tag write fails.
    public static var ndefReaderSessionErrorTagUpdateFailure: Code = .ndefReaderSessionErrorTagUpdateFailure
    /// NDEF tag memory size is too small to store the desired data.
    public static var ndefReaderSessionErrorTagSizeTooSmall: Code = .ndefReaderSessionErrorTagSizeTooSmall
    /// NDEF tag does not contain any NDEF message.
    public static var ndefReaderSessionErrorZeroLengthMessage: Code = .ndefReaderSessionErrorZeroLengthMessage
    
    public static var errorDomain: String = ErrorDomain
    
    public var code: Code
    public var errorCode: Int
    public var errorUserInfo: [String : Any]
    public var errorDescription: String?
}

extension ReaderError: Equatable {
    public static func == (lhs: ReaderError, rhs: ReaderError) -> Bool {
        return lhs.errorCode == rhs.errorCode
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 11.0, *)
    public static func == (lhs: ReaderError, rhs: CoreNFC.NFCReaderError) -> Bool {
        return lhs.errorCode == rhs.errorCode
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 11.0, *)
    public static func == (lhs: CoreNFC.NFCReaderError, rhs: ReaderError) -> Bool {
        return lhs.errorCode == rhs.errorCode
    }
    #endif
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 11.0, *)
public extension CoreNFC.NFCReaderError {
    init?(from nfcKitInstance: ReaderError) {
        guard let code = CoreNFC.NFCReaderError.Code.init(rawValue: nfcKitInstance.code.rawValue) else {
            return nil
        }
        self.init(code, userInfo: nfcKitInstance.errorUserInfo)
    }
}
#endif
