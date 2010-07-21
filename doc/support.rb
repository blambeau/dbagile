$LOAD_PATH.unshift(File.expand_path('../', __FILE__))

begin
  wlang_lib = File.expand_path('../../../wlang/lib', __FILE__)
  puts wlang_lib
  $LOAD_PATH.unshift(wlang_lib)
  require 'wlang'
  puts "Using local wlang"
rescue LoadError
  puts "Using gem wlang"
  require 'rubygems'
  gem 'wlang', ">= 0.9.2"
  require 'wlang'
end
require 'rubygems'
require 'coderay'
require 'RedCloth'
require 'wlang/dialects/xhtml_dialect'
require 'wlang/dialects/coderay_dialect'
require 'wlang/dialects/redcloth_dialect'


require 'support/wlang_dialects'
require 'support/doc'