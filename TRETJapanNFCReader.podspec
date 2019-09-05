Pod::Spec.new do |spec|
  spec.name         = "TRETJapanNFCReader"
  spec.version      = "0.0.7"
  spec.summary      = "日本のNFCカード向けリーダーライブラリ（iOS 13.0 以降）"
  spec.description  = <<-DESC
			日本のNFCカード向けリーダーライブラリ（iOS 9.3 以降、NFCカードの読み取りは iOS 13.0 以降）。Suica、PASMOなどの交通系ICカード、楽天Edy、nanaco、WAON、運転免許証の読み取り。日本語・英語に対応 Japanese & English Support!
                   DESC

  spec.homepage     = "https://github.com/treastrain/TRETJapanNFCReader"
  # spec.screenshots  = ""
  spec.license      = "MIT"
  spec.author             = { "treastrain / Tanaka Ryoga" => "tr@tret.jp" }
  spec.social_media_url   = "https://twitter.com/treastrain"

  spec.platforms = { :ios => "9.3", :osx => "10.9", :watchos => "4.3", :tvos => "9.2" }
  spec.swift_version  = "5.0"

  spec.source       = { :git => "https://github.com/treastrain/TRETJapanNFCReader.git", :tag => "#{spec.version}" }

  spec.source_files = 'TRETJapanNFCReader/**/*.{swift}'

  spec.requires_arc = true
end
