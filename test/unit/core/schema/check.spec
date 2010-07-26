require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema checking" do
  
  subject{ lambda{ schema.check! } }
  
  [:dbagile,
   :left, :right, 
   :suppliers_and_parts].each{|k|
    it "should be ok on #{k}" do
      schema = DbAgile::Fixtures::Core::Schema::schema(k)
      lambda{ schema.check! }.should_not raise_error
    end
  }

  describe "when called on an invalid schema" do
    let(:schema){ DbAgile::Fixtures::Core::Schema::schema(:invalid) }
    specify{ 
      subject.should raise_error(DbAgile::SchemaSemanticsError) 
      
      # each relvar has exactly one error except:
      #   - VALID, which is valid -> -1
      #   - EMPTY (no pkey, empty heading) -> +1
      expected_size =  schema.logical.size - 1 + 1
      
      # each index has exactly one error
      expected_size += schema.physical.indexes.size
      
      schema.check!(false).size.should == expected_size
    }
  end

end