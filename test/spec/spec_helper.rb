$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../fixtures', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../support', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'dbagile'
require 'dbagile/commands'
require 'spec'
require 'spec/autorun'

require 'fixtures'

DbAgile::user_config_file = Fixtures::dbagile_config_path

Spec::Runner.configure do |config|
end
