require File.expand_path('../../spec_helper.rb', __FILE__)
env = DbAgile::default_environment
env.config_file_path = Fixtures::dbagile_config_path
DbAgile::default_environment = env
dbagile = DbAgile::Command
file = Fixtures::join_path('ruby_values')

dbagile.use %w{sqlite}
dbagile.import %{--ruby --create-table --input=#{file}_source.rb ruby_values}
dbagile.export %{--csv --type-system=ruby --output=#{file}.csv ruby_values}
dbagile.export %{--json --output=#{file}.json ruby_values}
dbagile.export %{--yaml --output=#{file}.yaml ruby_values}
dbagile.export %{--ruby --output=#{file}.rb ruby_values}
