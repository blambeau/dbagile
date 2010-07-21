require 'rubygems'
require 'coderay'
require 'RedCloth'

$LOAD_PATH.unshift(File.expand_path('../../../wlang/lib', __FILE__))
require 'wlang'
require 'wlang/dialects/xhtml_dialect'
require 'wlang/dialects/coderay_dialect'
require 'wlang/dialects/standard_dialects'

module DbAgile
  module Doc
    
    # Converts something to a link
    def self.to_link(txt)
      if txt =~ /^([A-Z][a-zA-Z]+)(::[A-Z][a-zA-Z]+)*$/
        url = "http://rdoc.info/projects/blambeau/dbagile"
        "<a href=\"#{url}\" target=\"_blank\">#{txt}</a>"
      else
        puts "Warning, not a valid link: #{txt}"
        txt
      end
    end
    
  end
end 

WLang::dialect('wdoc') do

  dialect("wtext", ".wtxt") do
    encoders WLang::EncoderSet::XHtml
    rules WLang::RuleSet::Basic
    rules WLang::RuleSet::Encoding
    rules WLang::RuleSet::Imperative
    rules WLang::RuleSet::Buffering
    rules WLang::RuleSet::Context
    rules WLang::RuleSet::XHtml
    rule '@:' do |parser,offset|
      text, reached = parser.parse(offset)
      [DbAgile::Doc::to_link(text), reached]
    end
  end
  
  dialect("wjs", ".wjs") do
    post_transform{|txt| 
      encoded = WLang::encode(txt, "xhtml/coderay/javascript")
      "<notextile>#{encoded}</notextile>"
    }
  end
  
end