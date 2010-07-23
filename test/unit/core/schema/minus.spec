require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#minus" do
  
  let(:left)   { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:right)  { DbAgile::Fixtures::Core::Schema::schema(:right) }
  let(:l_m_r){ left.minus(right) }
  let(:r_m_l){ right.minus(left) }
  
  it "should be a valid Schema" do
    l_m_r.should be_kind_of(DbAgile::Core::Schema)
    r_m_l.should be_kind_of(DbAgile::Core::Schema)
  end
  
  it "should be as expected" do
    (left - right).should_not be_empty
    (right - left).should_not be_empty
  end

  it "should be clean when comparing equal schema" do
    (left - left).should be_empty
    (right - right).should be_empty
  end

end