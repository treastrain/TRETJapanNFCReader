Pod::Spec.new do |spec|
  spec.name         = "TRETJapanNFCReader"
  spec.version      = "2.0.1"
  spec.summary      = "日本のNFCカード向けリーダーライブラリ（iOS、watchOS、tvOS、macOS）"
  spec.description  = <<-DESC
			日本のNFCカード向けリーダーライブラリ（NFCカードの読み取りは iOS 13.0 以降のみ）。Suica、PASMOなどの交通系ICカード、楽天Edy、nanaco、WAON、運転免許証の読み取り。日本語・英語に対応 Japanese & English Support!
                   DESC

  spec.homepage     = "https://github.com/treastrain/TRETJapanNFCReader"
  # spec.screenshots  = ""
  spec.license      = "MIT"
  spec.author             = { "treastrain / Tanaka Ryoga" => "tr@tret.jp" }
  spec.social_media_url   = "https://twitter.com/treastrain"

  spec.platforms = { :ios => "9.3", :osx => "10.9", :watchos => "4.2", :tvos => "9.2" }
  spec.swift_version  = "5.1.3"

  spec.source       = { :git => "https://github.com/treastrain/TRETJapanNFCReader.git", :tag => "#{spec.version}" }

  spec.source_files = 'Sources/**/*.{swift}'

  spec.requires_arc = true
end
