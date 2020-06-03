![](TRETJapanNFCReader.png)

# TRETJapanNFCReader
日本のNFCカード向けリーダーライブラリ / NFC Reader for Japanese NFC Cards for iOS etc.

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/treastrain/TRETJapanNFCReader/blob/master/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/treastrain/TRETJapanNFCReader)](https://github.com/treastrain/TRETJapanNFCReader/stargazers)
![Platform: iOS|watchOS|tvOS|macOS](https://img.shields.io/badge/Platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-lightgrey.svg)
![Swift: 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/treastrain/TRETJapanNFCReader)
[![CocoaPods](https://img.shields.io/cocoapods/v/TRETJapanNFCReader?label=CocoaPods)](https://cocoapods.org/pods/TRETJapanNFCReader)

Support: [![Twitter: @JapanNFCReader](https://img.shields.io/twitter/follow/JapanNFCReader?label=%40JapanNFCReader&style=social)](https://twitter.com/JapanNFCReader)
Developer [![Twitter: @treastrain](https://img.shields.io/twitter/follow/treastrain?label=%40treastrain&style=social)](https://twitter.com/treastrain)

This library provides read functionallity for prepaid transportation cards such as Suica or PASMO, electronic money cards such as RakutenEdy, nanaco or WAON, Drivers License Card, and Individual Number Card.

## Supported OS
- iOS 9.3 +
- watchOS 2.0 +
- tvOS 9.2 +
- macOS 10.9 +

Note: NFC Card Reader is only available for iOS 13.0+ devices which supports NFC.


## Supported NFC card
### NFC-B (Type-B)
- [x] Drivers License Card
- Support "The spec of Drivers License Card, issue system, and more (version: 008)" (運転免許証及び運転免許証作成システム等仕様書（仕様書バージョン番号:008）) by License Division, Traffic Bureau, National Police Agency
- Current support: Reading functionality of Common data element (MF/EF01) and PIN configuration (MF/FE01), authentication with PIN 1, matters to be included (except fot one's legal domicile) (DF1/EF01), and ID photos (DF2/EF01)
- [x] Individual Number Card
- Current support: Reading IC Card Type, and Individual Number

### NFC-F (Type-F, FeliCa)
Displaying IDm and System Code
- [x] 0003: Transportation IC Card (Suica, ICOCA, Kitaca, PASMO, TOICA, manaca, PiTaPa, SUGOCA, nimoca, Hayakaken (はやかけん), icsca, ...etc.)
    - Read and display balances
    - Read usage history, ticket gate entrance and exit history, and Stored Fare (SF) entrance information
- [x] 80DE: IruCa
    - Read and display balances
    - Read usage history, ticket gate entrance and exit history, and Stored Fare (SF) entrance information
- [x] 8592: PASPY
    - Read and display balances
    - Read usage history, ticket gate entrance and exit history, and Stored Fare (SF) entrance information
- [x] 865E: SAPICA
    - Read and display balances
    - Read usage history, ticket gate entrance and exit history, and Stored Fare (SF) entrance information
- [x] 8FC1: OKICA
    - Read and display balances
    - Read usage history, ticket gate entrance and exit history, and Stored Fare (SF) entrance information
- [x] 8B5D: Ryuto (りゅーと)
    - Read and display balances
    - Read usage history
- [x] FE00: RakutenEdy (楽天Edy)
    - Read and display balances
    - Read usage history
- [x] FE00: nanaco
    - Read and display balances
    - Read usage history
- [x] FE00: WAON
    - Read and display balances
    - Read usage history
- [x] FE00: University Coop prepaid card (大学生協プリペイドカード（大学 学生証）)
    - Read and display balances
    - Read usage history
- [x] 8008: Octopus (八達通)
    - Read and display balances


## How to use
You can also refer to the samples in `Examples` directory
### Swift Package Manager
Xcode 11: File > Swift Package > Add Package Dependency... > Enter package repository URL
```
https://github.com/treastrain/TRETJapanNFCReader
```
### Carthage
Put the following sentence to `Cartfile`, and run `carthage update`
```
github "treastrain/TRETJapanNFCReader"
```
### CocoaPods
Put the following sentence to `Podfile`, and run `pod install`
```
pod 'TRETJapanNFCReader'
```

### Common configuration for all the NFC cards
1. Select your iOS Applications from Projects's TARGET, and enable Near Field Communication Tag Reading im Signing & Capabilities (Please make sure Near Field Communication Tag Reader Session Formats is included in entitlements file).
2. Make sure "NFC tag-specific data protocol (TAG)" is included in Near Field Communication Tag Reader Session Formats.
3. Add "Privacy - NFC Scan Usage Description (NFCReaderUsageDescription)" to your iOS Application's Info.plist.

### NFC-B (Type-B)
#### Drivers License Card
1. To read Drivers License Card, add "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" to your iOS Application's Info.plist. You need to include the followings in ISO7816 application identifiers for NFC Tag Reader Session.
- Item 0: `A0000002310100000000000000000000`
- Item 1: `A0000002310200000000000000000000`
- Item 2: `A0000002480300000000000000000000`

2. Import library, initalize `DriversLicenseReader`, and start scanning.
```swift
import UIKit
import TRETJapanNFCReader
class ViewController: UIViewController, DriversLicenseReaderSessionDelegate {

    var reader: DriversLicenseReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(self)
        self.reader.get(items: DriversLicenseCardItem.allCases, pin1: "PIN 1", pin2: "PIN 2")
    }

    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard) {
        // Drivers License Card data is in driversLicenseCard
    }
}
```

#### Individual Number Card
1. To read Individual Number Card, add "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" to your iOS Application's Info.plist. You need to include the followings in ISO7816 application identifiers for NFC Tag Reader Session.
- Item 0: `D392F000260100000001`
- Item 1: `D3921000310001010408`
- Item 2: `D3921000310001010100`
- Item 3: `D3921000310001010401`

2. Import library, initalize `IndividualNumberReader`, and start scanning.
```swift
import UIKit
import TRETJapanNFCReader
class ViewController: UIViewController, IndividualNumberReaderSessionDelegate {

    var reader: IndividualNumberReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Specify the data you want
        let items: [IndividualNumberCardItem] = [.tokenInfo, .individualNumber]
        // Card input support password
        let cardInfoInputSupportAppPIN = "1234"
        
        self.reader = IndividualNumberReader(delegate: self)
        self.reader.get(items: items, cardInfoInputSupportAppPIN: cardInfoInputSupportAppPIN)
    }

    func individualNumberReaderSession(didRead individualNumberCardData: IndividualNumberCardData) {
        print(individualNumberCardData)
    }

    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }

    // To get the remaining trial number of password input
    func lookupRemaining() {
        // Specify the type of the remaining trial number 
        let pinType: IndividualNumberCardPINType = .digitalSignature
        
        self.reader.lookupRemainingPIN(pinType: pinType) { (remaining) in
            print("Remaining:", remaining)
        }
    }
}
```

### NFC-F (Type-F, FeliCa)
- To read FeliCa, add "ISO18092 system codes for NFC Tag Reader Session (com.apple.developer.nfc.readersession.felica.systemcodes)" to your iOS Application's Info.plist, and specify FeliCa system code. You cannot use wild card for it.
Each card has corresponding `Reader` and `Card`.

|Type of Card|FeliCa System Code|`Reader`|`Card`|
|:--|:--|:--|:--|
|Transportation IC Card|`0003`|`TransitICReader`|`TransitICCard`|
|IruCa|`80DE`|`TransitICReader`|`TransitICCard`|
|PASPY|`8592`|`TransitICReader`|`TransitICCard`|
|SAPICA|`865E`|`TransitICReader`|`TransitICCard`|
|Ryuto (りゅーと)|`8B5D`|`RyutoReader`|`RyutoCard`|
|OKICA|`8FC1`|`OkicaReader`|`OkicaCard`|
|RakutenEdy (楽天Edy)|`FE00`|`RakutenEdyReader`|`RakutenEdyCard`|
|nanaco|`FE00`|`NanacoReader`|`NanacoCard`|
|WAON|`FE00`|`WaonReader`|`WaonCard`|
|University Coop Prepaid IC Card|`FE00`|`UnivCoopICPrepaidReader`|`UnivCoopICPrepaidCard`|
|FCFCampus (International Christian University)|`FE00`|`ICUReader`|`ICUCard`|
|Octopus (八達通)|`8008`|`OctopusReader`|`OctopusCard`|

#### Usage Example
Following is the example for Rakuten Edy. Each `Reader` and `Card` must be replaced with the item corresponding to in the above table.
```swift
import UIKit
import TRETJapanNFCReader
class ViewController: UIViewController, FeliCaReaderSessionDelegate {

    var reader: RakutenEdyReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = RakutenEdyReader(viewController: self)
        self.reader.get(items: [.balance])
    }

    func feliCaReaderSession(didRead feliCaCard: FeliCaCard) {
        let rakutenEdyCard = feliCaCard as! RakutenEdyCard
        let balance = rakutenEdyCard.balance! // Card Balance
    }
}
```


## L10N
- 日本語 Japanese
- English


## Related Works
- [treastrain/ios13-felica-reader: Sample project to read FeliCa on iOS 13 and later - GitHub](https://github.com/treastrain/ios13-felica-reader)
- [Read FeliCa (Suica) with iOS 13 (iOS 13 で FeliCa (Suica) にアクセス) | notes from E](https://notes.tret.jp/ios13-felica-reading/)
- [Let's read Drivers License Card with Core NFC in iOS 13 (iOS 13 の Core NFC で運転免許証を読み取ろう)【TRETJapanNFCReader】 - Qiita](https://qiita.com/treastrain/items/f95ee3f99c6b6111e999)


## Acknowledgments
### MiFare `TRETJapanNFCReader/MIFARE`
- ISO/IEC7816
- JIS X 6320-4

### Individual Number Card `TRETJapanNFCReader/MIFARE/IndividualNumber`
To implement reading functionality for Individual Number Card, I refered to these pages.
- [`jpki/myna`](https://github.com/jpki/myna)
- User client software API specs for the public personal authentication service (vol. Personal authentication service AP C Language interface) version 4.3 Japan Agency for Local Authority Information Systems (公的個人認証サービス 利用者クライアントソフト API 仕様書【個人認証サービス AP C 言語インターフェース編】第4.3版 地方公共団体情報システム機構)


### OKICA `TRETJapanNFCReader/FeliCa/Okica/`
Data of OKICA, and Yui rails (ゆいレール) station names and the information of the bus companies were provided by [Twitter@resi098](https://twitter.com/resi098)-san.

### University Coop Prepaird IC Card `TRETJapanNFCReader/FeliCa/UnivCoopICPrepaid`
To implement the reading functionality for University Coop Prepaird IC Card, I refered to these specs.
- `oboenikui/UnivFeliCa.md`
    - [The spec of University Coop FeliCa (大学生協FeliCaの仕様)](https://gist.github.com/oboenikui/ee9fb0cb07a6690c410b872f64345120)

### Octopus (八達通) `TRETJapanNFCReader/FeliCa/Octopus`
- [Octopus · metrodroid/metrodroid Wiki](https://github.com/metrodroid/metrodroid/wiki/Octopus)

The names of e-money and the services are generally trademarks and registered trademarks of each company.
This library is not officially provided by e-money card service providers and others.
