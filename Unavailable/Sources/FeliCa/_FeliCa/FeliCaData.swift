//
//  FeliCaData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/01/02.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public typealias FeliCaData = [FeliCaSystemCode : FeliCaSystem]

extension FeliCaData {
    
    public subscript(parameter: FeliCaReadWithoutEncryptionCommandParameter) -> FeliCaBlockData? {
        return self[parameter.systemCode]?[parameter.serviceCode]
    }
}
