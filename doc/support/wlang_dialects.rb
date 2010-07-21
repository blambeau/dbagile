WLang::dialect('wdoc') do

  # WLang-ed textile
  dialect("wtext", ".wtxt") do
    # We take xhtml encoders
    encoders WLang::EncoderSet::XHtml
    
    # A lot of rules
    rules WLang::RuleSet::Basic
    rules WLang::RuleSet::Encoding
    rules WLang::RuleSet::Imperative
    rules WLang::RuleSet::Buffering
    rules WLang::RuleSet::Context
    rules WLang::RuleSet::XHtml
    
    # Rule dedicated to @{...} links
    rule '@' do |parser,offset|
      text, reached = parser.parse(offset, "wlang/active-string")
      [DbAgile::Doc::to_link(text), reached]
    end
    
    # Post transformation trhough RedCloth
    post_transform "redcloth/xhtml"
  end
  
  # WLang-ed javascript to be included inside textile
  dialect("wjs", ".wjs") do
    post_transform{|txt| 
      encoded = WLang::encode(txt, "xhtml/coderay/javascript")
      "<notextile>#{encoded}</notextile>"
    }
  end
  
end