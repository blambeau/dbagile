require File.join(File.dirname(__FILE__), 'spec_helper')
test_files = Dir[File.join(File.dirname(__FILE__), '*_specs.rb')]
test_files.each { |file|
  ::Kernel.load(file) 
}