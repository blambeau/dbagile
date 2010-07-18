$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'rubygems'
require 'dbagile'
require 'fixtures'
require 'spec'
require 'spec/autorun'
require 'fileutils'

Spec::Runner.configure do |config|
end
