$LOAD_PATH.unshift(File.expand_path('../', __FILE__))

require 'uri'
begin
  wlang_lib = File.expand_path('../../../wlang/lib', __FILE__)
  $LOAD_PATH.unshift(wlang_lib)
  require 'wlang'
  require 'wlang/dialects/xhtml_dialect'
  require 'wlang/dialects/coderay_dialect'
  require 'wlang/dialects/redcloth_dialect'
rescue LoadError
  puts "Using gem wlang"
  require 'rubygems'
  gem 'wlang', ">= 0.9.2"
  require 'wlang'
  require 'wlang/dialects/xhtml_dialect'
  require 'wlang/dialects/coderay_dialect'
  require 'wlang/dialects/redcloth_dialect'
end

require 'rubygems'
require 'coderay'
require 'RedCloth'
require 'support/doc'