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
    rules DbAgile::Doc::WLang::Rules
    
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
  
  # WLang-ed ruby to be included inside textile
  dialect("wrb", ".wrb") do
    post_transform{|txt| 
      encoded = WLang::encode(txt, "xhtml/coderay/ruby")
      "<notextile>#{encoded}</notextile>"
    }
  end
  
  # WLang-ed shell to be included inside textile
  dialect("wsh", ".wsh") do
    post_transform{|txt| 
      "<notextile><div class=\"CodeRay\"><pre>#{txt}</pre></div></notextile>"
    }
  end
  
end

# We need to oveeride hard-coding of 'a' on wlang/xhtml
xhtml = WLang::dialect('wlang/xhtml')
xhtml.add_rule('@'){|parser, offset| DbAgile::Doc::WLang::Rules.at(parser, offset)}