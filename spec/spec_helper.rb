$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'flexidb'
require 'spec'
require 'spec/autorun'

# require spec support files
Dir[File.expand_path('../support/**/*.spec', __FILE__)].each { |f| require f }

Spec::Runner.configure do |config|
end
