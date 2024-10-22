//
//  FeliCaStatusFlag.swift
//  FeliCa
//
//  Created by treastrain on 2024/10/23.
//

public import Foundation

public struct FeliCaStatusFlag: Sendable {
    public let flag1: UInt8
    public let flag2: UInt8
    
    public init(_ flag1: Int, _ flag2: Int) {
        self.init(UInt8(flag1), UInt8(flag2))
    }
    
    public init(_ flag1: UInt8, _ flag2: UInt8) {
        self.flag1 = flag1
        self.flag2 = flag2
    }
    
    public func get() throws(Error) {
        switch (flag1, flag2) {
        case (0x00, 0x00):
            break
        case (let locationRawValue, let statusFlag2):
            let location = Error.Location(rawValue: locationRawValue)
            throw Error(statusFlag2: statusFlag2, location: location)
        }
    }
}

extension FeliCaStatusFlag {
    public enum Error: LocalizedError, Sendable {
        public init(statusFlag2: UInt8, location: Location) {
            switch statusFlag2 {
            case 0x00: self = .successful
            case 0x01: self = .purseDataUnderflowOrOverflow(location)
            case 0x02: self = .cashbackDataOverflow(location)
            case 0x03: self = .limitedPurseDataOutOfRange(location)
            case 0x70: self = .memoryError(location)
            case 0x71: self = .numberOfRewritesExceedsUpperLimit(location)
            case 0x01...0x7F: self = .commonSpecError(statusFlag2, location)
            case 0xA1: self = .illegalNumberOfService(location)
            case 0xA2: self = .illegalCommandPacket(location)
            case 0xA3: self = .illegalBlockListOrderOfService(location)
            case 0xA4: self = .illegalServiceType(location)
            case 0xA5: self = .accessIsNotAllowed(location)
            case 0xA6: self = .illegalServiceCodeList(location)
            case 0xA7: self = .illegalBlockListAccessMode(location)
            case 0xA8: self = .illegalBlockNumber(location)
            case 0xA9: self = .dataWriteFailure(location)
            case 0xAA: self = .keyChangeFailure(location)
            case 0xAB: self = .illegalPackageParityOrIllegalPackageMAC(location)
            case 0xAC: self = .illegalParameter(location)
            case 0xAD: self = .serviceExistsAlready(location)
            case 0xAE: self = .illegalSystemCode(location)
            case 0xAF: self = .tooManySimultaneousCyclicWriteOperations(location)
            case 0xC0: self = .illegalPackageIdentifier(location)
            case 0xC1: self = .discrepancyOfParametersInsideAndOutsidePackage(location)
            case 0xC2: self = .commandIsDisabledAlready(location)
            case 0xC3: self = .illegalNodeProperty(location)
            case 0x80...0xFF: self = .cardSpecError(statusFlag2, location)
            default: fatalError()
            }
        }
        
        case successful
        case purseDataUnderflowOrOverflow(_ location: Location)
        case cashbackDataOverflow(_ location: Location)
        case limitedPurseDataOutOfRange(_ location: Location)
        case memoryError(_ location: Location)
        case numberOfRewritesExceedsUpperLimit(_ location: Location)
        case commonSpecError(_ statusFlag2: UInt8, _ location: Location)
        case illegalNumberOfService(_ location: Location)
        case illegalCommandPacket(_ location: Location)
        case illegalBlockListOrderOfService(_ location: Location)
        case illegalServiceType(_ location: Location)
        case accessIsNotAllowed(_ location: Location)
        case illegalServiceCodeList(_ location: Location)
        case illegalBlockListAccessMode(_ location: Location)
        case illegalBlockNumber(_ location: Location)
        case dataWriteFailure(_ location: Location)
        case keyChangeFailure(_ location: Location)
        case illegalPackageParityOrIllegalPackageMAC(_ location: Location)
        case illegalParameter(_ location: Location)
        case serviceExistsAlready(_ location: Location)
        case illegalSystemCode(_ location: Location)
        case tooManySimultaneousCyclicWriteOperations(_ location: Location)
        case illegalPackageIdentifier(_ location: Location)
        case discrepancyOfParametersInsideAndOutsidePackage(_ location: Location)
        case commandIsDisabledAlready(_ location: Location)
        case illegalNodeProperty(_ location: Location)
        case cardSpecError(_ statusFlag2: UInt8, _ location: Location)
    }
}

extension FeliCaStatusFlag.Error {
    public struct Location: OptionSet, Sendable {
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        public let rawValue: UInt8
        
        public static let firstOrNineth = Location(rawValue: 1 << 0)
        public static let secondOrTenth = Location(rawValue: 1 << 1)
        public static let thirdOrEleventh = Location(rawValue: 1 << 2)
        public static let fourthOrTwelfth = Location(rawValue: 1 << 3)
        public static let fifthOrThirteenth = Location(rawValue: 1 << 4)
        public static let sixthOrFourteenth = Location(rawValue: 1 << 5)
        public static let seventhOrFifteenth = Location(rawValue: 1 << 6)
        public static let eighth = Location(rawValue: 1 << 7)
    }
}
