require File.expand_path('../../spec_helper.rb', __FILE__)
file = Fixtures::join_path('ruby_values')

DbAgile::command do |env, dbagile|
  # Set the environment
  env.config_file_path = Fixtures::dbagile_config_path
  
  # Make the job now
  dbagile.use %w{sqlite}
  dbagile.import %{--ruby --create-table --input=#{file}_source.rb ruby_values}
  dbagile.export %{--csv --type-system=ruby --output=#{file}.csv ruby_values}
  dbagile.export %{--json --output=#{file}.json ruby_values}
  dbagile.export %{--yaml --output=#{file}.yaml ruby_values}
  dbagile.export %{--ruby --output=#{file}.rb ruby_values}
end

