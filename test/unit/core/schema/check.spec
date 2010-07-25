require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema checking" do
  
  let(:schema){ DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }
  
  describe "when called on a valid schema" do
    specify{ 
      schema.semantical_errors.should be_empty 
    }
  end
  
end