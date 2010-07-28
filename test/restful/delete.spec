shared_examples_for("The Restful DELETE interface") do
  
  before(:each){ DbAgile::Fixtures::restore_basic_values(database) }
  after(:each) { DbAgile::Fixtures::restore_basic_values(database) }
  
  dbagile_install_examples(__FILE__, self)
  
end