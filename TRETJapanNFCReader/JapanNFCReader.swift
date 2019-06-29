//
//  JapanNFCReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

open class JapanNFCReader: NSObject, NFCTagReaderSessionDelegate {
    
    private let viewController: UIViewController
    internal var session: NFCTagReaderSession?
    
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    internal func checkReadingAvailable() -> Bool {
        guard NFCTagReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: NSLocalizedString("nfcReadingUnavailableAlertTitle", bundle: Bundle(for: type(of: self)), comment: ""),
                message: NSLocalizedString("nfcReadingUnavailableAlertMessage", bundle: Bundle(for: type(of: self)), comment: ""),
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewController.present(alertController, animated: true, completion: nil)
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
                let alertController = UIAlertController(
                    title: NSLocalizedString("nfcTagReaderSessionDidInvalidateWithErrorAlertTitle", bundle: Bundle(for: type(of: self)), comment: ""),
                    message: readerError.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.viewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        self.session = nil
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("tagReaderSession(_:didDetect:)")
        session.invalidate()
    }
}

