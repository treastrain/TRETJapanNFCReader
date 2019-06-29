//
//  DriversLicenseReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/29.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

public protocol DriversLicenseReaderSessionDelegate {
    func driversLicenseReaderSession(didInvalidateWithError error: Error)
    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard)
}

