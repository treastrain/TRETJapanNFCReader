//
//  DriversLicenseReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/29.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
public protocol DriversLicenseReaderSessionDelegate: JapanNFCReaderSessionDelegate {
    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard)
}

