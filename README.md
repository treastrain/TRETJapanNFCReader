# 🏎️ Road to TRETNFCKit
We are moving away from the pattern of delegation and are being reborn as something that can take advantage of Swift Concurrency.
Please refer to this branch: [`tretnfckit-main`](https://github.com/treastrain/TRETJapanNFCReader/tree/tretnfckit-main)

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

Suica、PASMOなどの交通系ICカード、楽天Edy、nanaco、WAON などの電子マネーカード、運転免許証、マイナンバーカードの読み取り

## 対応 OS / Supported OS
- iOS 9.3 以降
- watchOS 2.0 以降
- tvOS 9.2 以降
- macOS 10.9 以降

※ NFCカードの読み取りは iOS 13.0 以降で対応するデバイスで使用可能。


## 対応 NFC カード / Supported NFC card
### NFC-B (Type-B)
- [x] 運転免許証
- 警察庁交通局運転免許課による「運転免許証及び運転免許証作成システム等仕様書（仕様書バージョン番号:008）」に対応
- 共通データ要素（MF/EF01）、暗証番号(PIN)設定（MF/EF02）の読み取り、暗証番号1による認証、記載事項(本籍除く)（DF1/EF01）写真（DF2/EF01）まで実装済み
- [x] マイナンバーカード（個人番号カード、Individual Number Card）
- ICカード種別情報（JPKI_CardType）、マイナンバーの読み取りまで実装済み

### NFC-F (Type-F, FeliCa)
IDm と System Code の表示
- [x] 0003: 交通系ICカード (Suica, ICOCA, Kitaca, PASMO, TOICA, manaca, PiTaPa, SUGOCA, nimoca, はやかけん, icsca, ...etc.)
    - 残高の読み取りと表示
    - 利用履歴、改札入出場履歴、SF入場情報の読み取り
- [x] 80DE: IruCa
    - 残高の読み取りと表示
    - 利用履歴、改札入出場履歴、SF入場情報の読み取り
- [x] 8592: PASPY
    - 残高の読み取りと表示
    - 利用履歴、改札入出場履歴、SF入場情報の読み取り
- [x] 865E: SAPICA
    - 残高の読み取りと表示
    - 利用履歴、改札入出場履歴、SF入場情報の読み取り
- [x] 8FC1: OKICA
    - 残高の読み取りと表示
    - 利用履歴、改札入出場履歴、SF入場情報の読み取り
- [x] 8B5D: りゅーと
    - 残高の読み取りと表示
    - 利用履歴の読み取り
- [x] FE00: 楽天Edy
    - 残高の読み取りと表示
    - 利用履歴の読み取り
- [x] FE00: nanaco
    - 残高の読み取りと表示
    - 利用履歴の読み取り
- [x] FE00: WAON
    - 残高の読み取りと表示
    - 利用履歴の読み取り
- [x] FE00: 大学生協プリペイドカード（大学 学生証）
    - 残高の読み取りと表示
    - 利用履歴の読み取り
- [x] 8008: 八達通
    - 残高の読み取りと表示


## 使い方 / How to use
`Examples` 配下にサンプルを掲載。
### Swift Package Manager
Xcode 11: File > Swift Package > Add Package Dependency... > Enter package repository URL
```
https://github.com/treastrain/TRETJapanNFCReader
```
### Carthage
`Cartfile` に以下を記述し、`carthage update`
```
github "treastrain/TRETJapanNFCReader"
```
### CocoaPods
`Podfile` に以下を記述し、`pod install`
```
pod 'TRETJapanNFCReader'
```

### 全 NFC カード共通
1. プロジェクトの TARGET から開発している iOS Application を選び、Signing & Capabilities で Near Field Communication Tag Reading を有効にする（Near Field Communication Tag Reader Session Formats が entitlements ファイルに含まれている必要がある）。
2. Near Field Communication Tag Reader Session Formats の中に "NFC tag-specific data protocol (TAG)" が含まれていることを確認する。
3. 開発している iOS Application の Info.plist に "Privacy - NFC Scan Usage Description (NFCReaderUsageDescription)" を追加する。

### NFC-B (Type-B)
#### 運転免許証の場合
1. 運転免許証を読み取るには、開発している iOS Application の Info.plist に "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" を追加する。ISO7816 application identifiers for NFC Tag Reader Session には以下を含める必要がある。
- Item 0: `A0000002310100000000000000000000`
- Item 1: `A0000002310200000000000000000000`
- Item 2: `A0000002480300000000000000000000`

2. ライブラリをインポートし、`DriversLicenseReader` を初期化した後でスキャンを開始する。
```swift
import UIKit
import TRETJapanNFCReader
class ViewController: UIViewController, DriversLicenseReaderSessionDelegate {

    var reader: DriversLicenseReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(self)
        self.reader.get(items: DriversLicenseCardItem.allCases, pin1: "暗証番号1", pin2: "暗証番号2")
    }

    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard) {
        // driversLicenseCard に読み取った運転免許証の情報が格納されている
    }
}
```

#### マイナンバーカードの場合
1. マイナンバーカードを読み取るには、開発している iOS Application の Info.plist に "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" を追加する。ISO7816 application identifiers for NFC Tag Reader Session には以下を含める必要がある。
- Item 0: `D392F000260100000001`
- Item 1: `D3921000310001010408`
- Item 2: `D3921000310001010100`
- Item 3: `D3921000310001010401`

2. ライブラリをインポートし、`IndividualNumberReader` を初期化した後でスキャンを開始する。
```swift
import UIKit
import TRETJapanNFCReader
class ViewController: UIViewController, IndividualNumberReaderSessionDelegate {

    var reader: IndividualNumberReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得したい情報を指定
        let items: [IndividualNumberCardItem] = [.tokenInfo, .individualNumber]
        // 券面入力補助用パスワード
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

    // パスワードの残り試行回数を取得する場合
    func lookupRemaining() {
        // 取得したい残り試行回数の種別を指定
        let pinType: IndividualNumberCardPINType = .digitalSignature
        
        self.reader.lookupRemainingPIN(pinType: pinType) { (remaining) in
            print("Remaining:", remaining)
        }
    }
}
```

### NFC-F (Type-F, FeliCa)
- FeliCa を読み取るには、開発している iOS Application の Info.plist に "ISO18092 system codes for NFC Tag Reader Session (com.apple.developer.nfc.readersession.felica.systemcodes)" を追加し、読み取る際に使用する FeliCa システムコードを記述する。ワイルドカードは使用できない。
各カードに対応する `Reader` と `Card` がある。

|カードの種類|FeliCa システムコード|`Reader`|`Card`|
|:--|:--|:--|:--|
|交通系IC|`0003`|`TransitICReader`|`TransitICCard`|
|IruCa|`80DE`|`TransitICReader`|`TransitICCard`|
|PASPY|`8592`|`TransitICReader`|`TransitICCard`|
|SAPICA|`865E`|`TransitICReader`|`TransitICCard`|
|りゅーと|`8B5D`|`RyutoReader`|`RyutoCard`|
|OKICA|`8FC1`|`OkicaReader`|`OkicaCard`|
|楽天Edy|`FE00`|`RakutenEdyReader`|`RakutenEdyCard`|
|nanaco|`FE00`|`NanacoReader`|`NanacoCard`|
|WAON|`FE00`|`WaonReader`|`WaonCard`|
|大学生協ICプリペイド|`FE00`|`UnivCoopICPrepaidReader`|`UnivCoopICPrepaidCard`|
|FCFCampus(ICU)|`FE00`|`ICUReader`|`ICUCard`|
|八達通|`8008`|`OctopusReader`|`OctopusCard`|

#### 使用例
楽天Edyの例。各`Reader`、`Card`は上記の表に対応するものに書き換える。
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
        let balance = rakutenEdyCard.balance! // カード残高
    }
}
```


## L10N
- 日本語 Japanese
- English


## 関連するページ / Related
- [treastrain/ios13-felica-reader: Sample project to read FeliCa on iOS 13 and later - GitHub](https://github.com/treastrain/ios13-felica-reader)
- [iOS 13 で FeliCa (Suica) にアクセス | notes from E](https://notes.tret.jp/ios13-felica-reading/)
- [iOS 13 の Core NFC で運転免許証を読み取ろう【TRETJapanNFCReader】 - Qiita](https://qiita.com/treastrain/items/f95ee3f99c6b6111e999)


## 謝辞 / Acknowledgments
### MiFare `TRETJapanNFCReader/MIFARE`
- ISO/IEC7816
- JIS X 6320-4

### マイナンバーカード `TRETJapanNFCReader/MIFARE/IndividualNumber`
マイナンバーカードの読み取り実装においては以下に掲載されている情報を参考にしました。
- [`jpki/myna`](https://github.com/jpki/myna)
- 公的個人認証サービス 利用者クライアントソフト API 仕様書【個人認証サービス AP C 言語インターフェース編】第4.3版 地方公共団体情報システム機構

### OKICA `TRETJapanNFCReader/FeliCa/Okica/`
OKICA の情報、および OKICA カード内に保存されているゆいレールの駅名情報、各バス会社名の情報は [Twitter@resi098](https://twitter.com/resi098) 様からご提供いただきました。

### 大学生協ICプリペイド `TRETJapanNFCReader/FeliCa/UnivCoopICPrepaid`
大学生協ICプリペイドの読み取り実装においては以下に掲載されている仕様を参考にしました。
- `oboenikui/UnivFeliCa.md`
    - [大学生協FeliCaの仕様](https://gist.github.com/oboenikui/ee9fb0cb07a6690c410b872f64345120)

### 八達通 `TRETJapanNFCReader/FeliCa/Octopus`
- [Octopus · metrodroid/metrodroid Wiki](https://github.com/metrodroid/metrodroid/wiki/Octopus)

各電子マネー、電子マネーサービス等の名称は一般に各社の商標、登録商標です。
本ライブラリはサービス提供各団体および各社、電子マネーカード提供各社が公式に提供するものではありません。

The names of e-money and the services are generally trademarks and registered trademarks of each company.
This library is not officially provided by e-money card service providers and others.
