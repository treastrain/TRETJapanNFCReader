![](TRETJapanNFCReader.png)

# TRETJapanNFCReader
NFC Reader for Japanese NFC Cards for iOS etc. / 日本の NFC カード向けリーダーライブラリ

Commands for FeliCa (NFC-F) and ISO7816-4 APDU (NFC-A, NFC-B) / FeliCa と ISO7816-4 APDU のコマンド群


[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/treastrain/TRETJapanNFCReader/blob/master/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/treastrain/TRETJapanNFCReader)](https://github.com/treastrain/TRETJapanNFCReader/stargazers)
![Platform: iOS|watchOS|tvOS|macOS](https://img.shields.io/badge/Platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-lightgrey.svg)
![Swift: 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/treastrain/TRETJapanNFCReader)
[![CocoaPods](https://img.shields.io/cocoapods/v/TRETJapanNFCReader?label=CocoaPods)](https://cocoapods.org/pods/TRETJapanNFCReader)

Support: [![Twitter: @JapanNFCReader](https://img.shields.io/twitter/follow/JapanNFCReader?label=%40JapanNFCReader&style=social)](https://twitter.com/JapanNFCReader)　
Developer [![Twitter: @treastrain](https://img.shields.io/twitter/follow/treastrain?label=%40treastrain&style=social)](https://twitter.com/treastrain)

```swift
import UIKit
import TRETJapanNFCReader

class ViewController: UIViewController, FeliCaReaderSessionDelegate {

    var reader: TransitICReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = TransitICReader(delegate: self)
        self.reader.get(items: [.balance])
    }

    func feliCaReaderSession(didRead feliCaCardData: FeliCaCardData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        let transitICCardData = feliCaCardData as! TransitICCardData
        print(transitICCardData.balance) // カード残高 / Balance
    }
    
    // ...
}
```

- Commands for FeliCa (NFC-F) and ISO7816-4 APDU (NFC-A, NFC-B) / FeliCa と ISO7816-4 APDU のコマンド
- `Reader` for reading cards / 各カードの読み取りのための`Reader`
  - [A list of supported cards can be found at here. / 対応カード一覧はこちらに記載。](#supportedCards)

## Supported OS / 対応 OS
- iOS 9.3+
- watchOS 2.0+
- tvOS 9.2+
- macOS 10.9+

**Note: The read NFC feature is only available for iOS 13.0+ devices which supports "NFC with reader mode". / NFCカードの読み取りは iOS 13.0 以降で "リーダーモード対応NFC" に対応したデバイスで使用可能。**

## Select the language of the README / README の言語を選択
- [English / 英語 : README_en.md](README_en.md)
- [日本語 / Japanese : README_ja.md](README_ja.md)

-----

<h2 id="supportedCards">Supported Cards / 対応カード</h2>

### NFC-A (Type-A)
- ISO/IEC 7816-4 (JIS X 6320-4) Compliance
  - Japanese Drivers License Card / ICカード運転免許証
  - Japanese Individual Number Card / 個人番号カード（マイナンバーカード）

### NFC-F (Type-F, FeliCa)
- Japanese Transit IC / 交通系ICカード（10カード）
  - Suica、PASMO、ICOCA、manaca、nimoca、PiTaPa、TOICA、SUGOCA、Kitaca、はやかけん
- Japanese Local Transit IC / 地方交通系ICカード
  - Transit IC compatible / 交通系ICカード互換
    - IruCa、PASPY、SAPICA
  - Proprietary / 独自規格
    - りゅーと
    - OKICA
- For consumers at Japan / 消費向け
  - Rakuten Edy / 楽天Edy
  - nanaco
  - WAON
  - Japanese Univ. co-op IC Prepaid / 大学生協ICプリペイド
- Octopus / 八達通 / オクトパス (Hong Kong / 香港)

## Related Works / 関連するページ
- [treastrain/ios13-felica-reader: Sample project to read FeliCa on iOS 13 and later - GitHub](https://github.com/treastrain/ios13-felica-reader)
- [treastrain/MyNumberPINRemainingChecker: マイナンバーカードのパスワードの残り試行回数を取得する iOS App サンプル](https://github.com/treastrain/MyNumberPINRemainingChecker)
- [iOS 13 で FeliCa (Suica) にアクセス | notes from E](https://notes.tret.jp/ios13-felica-reading/)
- [iOS 13 の Core NFC で運転免許証を読み取ろう【TRETJapanNFCReader】 - Qiita](https://qiita.com/treastrain/items/f95ee3f99c6b6111e999)
- [マイナンバーカードのパスワード残り試行回数を調べる | Qrunch（クランチ）](https://qrunch.net/@treastrain/entries/HytRhh1JcxKt0jXq)


## Acknowledgments / 謝辞
### MiFare `TRETJapanNFCReader/MIFARE`
- ISO/IEC7816
- JIS X 6320-4

### マイナンバーカード `TRETJapanNFCReader/MIFARE/IndividualNumber`
マイナンバーカードの読み取り実装においては以下に掲載されている情報を参考にしました。
- [`jpki/myna`](https://github.com/jpki/myna)
- 公的個人認証サービス 利用者クライアントソフト API 仕様書【個人認証サービス AP C 言語インターフェース編】第4.3版 地方公共団体情報システム機構

### OKICA `TRETJapanNFCReader/FeliCa/Okica`
OKICA の情報、および OKICA カード内に保存されているゆいレールの駅名情報、各バス会社名の情報は [Twitter@resi098](https://twitter.com/resi098) 様からご提供いただきました。

### 大学生協ICプリペイド `TRETJapanNFCReader/FeliCa/UnivCoopICPrepaid`
大学生協ICプリペイドの読み取り実装においては以下に掲載されている仕様を参考にしました。
- `oboenikui/UnivFeliCa.md`
    - [大学生協FeliCaの仕様](https://gist.github.com/oboenikui/ee9fb0cb07a6690c410b872f64345120)

### 八達通 `TRETJapanNFCReader/FeliCa/Octopus`
- [Octopus · metrodroid/metrodroid Wiki](https://github.com/metrodroid/metrodroid/wiki/Octopus)

-----

FeliCa is a trademark of Sony Corporation.
The names of e-money and the services are generally trademarks and registered trademarks of each company.
This library is NOT officially provided by e-money card service providers and others.

FeliCa はソニー株式会社の登録商標です。
各電子マネー、電子マネーサービス等の名称は一般に各社の商標、登録商標です。
本ライブラリはサービス提供各団体および各社、電子マネーカード提供各社が公式に提供するものではありません。
