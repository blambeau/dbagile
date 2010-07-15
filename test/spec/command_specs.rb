require File.join(File.dirname(__FILE__), 'spec_helper')
require 'dbagile/commands'
test_files = Dir[File.join(File.dirname(__FILE__), 'command/**/*.spec')]
test_files.each { |file|
  ::Kernel.load(file) 
}