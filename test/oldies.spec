require File.expand_path('../spec_helper', __FILE__)
Dir[File.expand_path('../oldies/**/*.spec', __FILE__)].each{|f| load(f)}
