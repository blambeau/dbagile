require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#minus" do
  
  let(:left)             { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:left_minus_right) { DbAgile::Fixtures::Core::Schema::schema(:left_minus_right)  }
  let(:right)            { DbAgile::Fixtures::Core::Schema::schema(:right)  }
  let(:right_minus_left) { DbAgile::Fixtures::Core::Schema::schema(:right_minus_left)  }
  
  it "should be a valid Schema" do
    (left - right).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    (left - left).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end
  
  it "should be as expected" do
    (left - right).should_not be_empty
    (left - right).look_same_as?(left_minus_right).should be_true
    (right - left).should_not be_empty
    (right - left).look_same_as?(right_minus_left).should be_true
  end

  it "should be clean when comparing equal schema" do
    (left - left).should be_empty
    (right - right).should be_empty
  end

end