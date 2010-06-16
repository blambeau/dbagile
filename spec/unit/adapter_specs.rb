require File.expand_path('../../spec_helper', __FILE__)
test_files = Dir[File.join(File.dirname(__FILE__), 'adapter/**/*.spec')]
test_files.each { |file|
  ::Kernel.load(file) 
}