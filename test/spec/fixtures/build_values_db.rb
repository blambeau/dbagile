require File.expand_path('../../spec_helper.rb', __FILE__)
env = DbAgile::default_environment
env.config_file_path = Fixtures::dbagile_config_path
DbAgile::default_environment = env
dbagile = DbAgile::Command
dbagile.use %w{sqlite}
dbagile.import %{--ruby --create-table --input=#{Fixtures::join_path('ruby_values_source.rb')} ruby_values}
dbagile.show %{ruby_values}
dbagile.export %{--csv --type-system=ruby --output=#{Fixtures::join_path('ruby_values.csv')} ruby_values}
dbagile.export %{--json --output=#{Fixtures::join_path('ruby_values.json')} ruby_values}
dbagile.export %{--ruby --output=#{Fixtures::join_path('ruby_values.rb')} ruby_values}