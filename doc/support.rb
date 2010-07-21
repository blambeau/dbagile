require 'rubygems'
require 'coderay'
require 'RedCloth'

$LOAD_PATH.unshift(File.expand_path('../../../wlang/lib', __FILE__))
require 'wlang'
require 'wlang/dialects/xhtml_dialect'
require 'wlang/dialects/coderay_dialect'
require 'wlang/dialects/standard_dialects'

WLang::dialect('wdoc') do

  dialect("wtext", ".wtxt") do
    encoders WLang::EncoderSet::XHtml
    rules WLang::RuleSet::Basic
    rules WLang::RuleSet::Encoding
    rules WLang::RuleSet::Imperative
    rules WLang::RuleSet::Buffering
    rules WLang::RuleSet::Context
    rules WLang::RuleSet::XHtml
  end
  
  dialect("wjs", ".wjs") do
    post_transform{|txt| 
      encoded = WLang::encode(txt, "xhtml/coderay/javascript")
      "<notextile>#{encoded}</notextile>"
    }
  end
  
end