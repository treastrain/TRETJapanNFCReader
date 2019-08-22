//
//  JapanNFCReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

public typealias JapanNFCReaderViewController = UIViewController & JapanNFCReaderSessionDelegate

@available(iOS 13.0, *)
open class JapanNFCReader: NSObject, NFCTagReaderSessionDelegate {
    
    internal let viewController: UIViewController?
    internal let japanNFCReaderSessionDelegate: JapanNFCReaderSessionDelegate?
    internal var session: NFCTagReaderSession?
    
    private override init() {
        self.viewController = nil
        self.japanNFCReaderSessionDelegate = nil
    }
    
    public init(delegate: JapanNFCReaderSessionDelegate) {
        self.viewController = nil
        self.japanNFCReaderSessionDelegate = delegate
    }
    
    public init(viewController: JapanNFCReaderViewController) {
        self.viewController = viewController
        self.japanNFCReaderSessionDelegate = viewController
    }
    
    public func checkReadingAvailable() -> Bool {
        guard NFCTagReaderSession.readingAvailable else {
            print("""
                ------------------------------------------------------------
                NFC のスキャンを開始することができませんでした。NFC の検出をサポートしている端末かどうか確認してください。
                NFC の検出をサポートしている端末であるにもかかわらず、このメッセージが表示される場合は以下を確認してください。
                \t• 他のアプリケーションで NFC を使用していた、または使用し終えた直後である場合などにこのメッセージが表示されることがあります。
                \t• プロジェクトの TARGET から開発している iOS Application を選び、Signing & Capabilities で Near Field Communication Tag Reading を有効にしてください（Near Field Communication Tag Reader Session Formats が entitlements ファイルに含まれている必要があります）。
                \t\t‣ Near Field Communication Tag Reader Session Formats の中には "NFC tag-specific data protocol (TAG)" が含まれていることを確認してください。
                \t• 開発している iOS Application の Info.plist に "Privacy - NFC Scan Usage Description (NFCReaderUsageDescription)" を追加してください。これを追加していない場合は実行時に signal SIGABRT エラーとなります。
                ------------------------------------------------------------
            """)
            
            if let viewController = self.viewController {
                let alertController = UIAlertController(
                    title: self.localizedString(key: "nfcReadingUnavailableAlertTitle"),
                    message: self.localizedString(key: "nfcReadingUnavailableAlertMessage"),
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alertController, animated: true, completion: nil)
            } else {
                self.japanNFCReaderSessionDelegate?.japanNFCReaderSession(didInvalidateWithError: JapanNFCReaderError.nfcReadingUnavailable)
            }
            
            return false
        }
        
        return true
    }
    
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive(_:)")
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("tagReaderSession(_:didInvalidateWithError:)")
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                if let viewController = self.viewController {
                    let alertController = UIAlertController(
                        title: self.localizedString(key: "nfcTagReaderSessionDidInvalidateWithErrorAlertTitle"),
                        message: readerError.localizedDescription,
                        preferredStyle: .alert
                    )
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        viewController.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    self.japanNFCReaderSessionDelegate?.japanNFCReaderSession(didInvalidateWithError: JapanNFCReaderError.nfcTagReaderSessionDidInvalidate)
                }
            }
        }
        
        self.session = nil
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("tagReaderSession(_:didDetect:)")
        session.invalidate()
    }
    
    func localizedString(key: String) -> String {
        return NSLocalizedString(key, bundle: Bundle.current, comment: "")
    }
}

