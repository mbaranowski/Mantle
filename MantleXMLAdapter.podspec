Pod::Spec.new do |s|
  s.name         = "MantleXMLAdapter"
  s.platform     = :ios, "5.0"
  s.version      = "0.2.0"
  s.summary      = "MantleXMLAdapter adds support to Mantle to create MTLModel objects from xml documents and (optionally) from models into xml documents."
  s.homepage     = "https://github.com/mbaranowski/MantleXMLAdapter"
  s.license      = "MIT"
  s.authors      = { "Matthew Baranowski" => "matt.baranowski@willowtreeapps.com" }
  s.source       = { :git => "https://github.com/mbaranowski/MantleXMLAdapter.git", :tag => '0.2.0' }
  s.source_files = 'Mantle/MTLXMLAdapter.{h,m}', 'Mantle/NSValueTransformer+MTLXMLTransformerAdditions.{h,m}'
  s.dependency  'KissXML'
  s.dependency  'Mantle'
  s.requires_arc = true
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end
