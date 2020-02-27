//
//  DriversLicenseReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/29.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
public protocol DriversLicenseReaderSessionDelegate: JapanNFCReaderSessionDelegate {
    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard)
}

#endif
