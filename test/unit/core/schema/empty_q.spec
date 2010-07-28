require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#empty?" do

  it "should not be empty on a non empty schema" do
    [:left, :right].each{|n|
      schema = DbAgile::Fixtures::Core::Schema::schema(n)
      schema.empty?.should be_false
    }
  end
  
  it "should be empty on a empty schema" do
    [:empty].each{|n|
      schema = DbAgile::Fixtures::Core::Schema::schema(n)
      schema.empty?.should be_true
    }
  end
  
end