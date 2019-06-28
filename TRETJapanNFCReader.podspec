Pod::Spec.new do |spec|
  spec.name         = "TRETJapanNFCReader"
  spec.version      = "0.0.1"
  spec.summary      = "日本のNFCカード向けリーダーライブラリ（iOS 13.0 以降）"
  spec.description  = <<-DESC
			日本のNFCカード向けリーダーライブラリ（iOS 13.0 以降）
                   DESC

  spec.homepage     = "https://github.com/treastrain/TRETJapanNFCReader"
  # spec.screenshots  = ""
  spec.license      = "MIT"
  spec.author             = { "treastrain / Tanaka Ryoga" => "tr@tret.jp" }
  spec.social_media_url   = "https://twitter.com/treastrain"

  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "https://github.com/treastrain/TRETJapanNFCReader.git", :tag => "#{spec.version}" }

  s.source_files = 'TRETJapanNFCReader/*.swift'

  spec.requires_arc = true
end
