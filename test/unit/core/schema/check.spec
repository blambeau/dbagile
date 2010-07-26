require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema checking" do
  
  subject{ lambda{ schema.check! } }
  
  describe "when called on a valid schema" do
    let(:schema){ DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }
    specify{ subject.should_not raise_error }
  end

  describe "when called on an invalid schema" do
    let(:schema){ DbAgile::Fixtures::Core::Schema::schema(:invalid) }
    specify{ 
      subject.should raise_error(DbAgile::SchemaSemanticsError) 
      schema.check!(false).size.should == (schema.logical.parts.size-1)
    }
  end

end