require File.expand_path('../fixtures.rb', __FILE__)
describe "The way comparison work" do
  
  it "should not override ==" do
    foo1 = DbAgile::Fixtures::Assumptions::FooComparable.new(1)
    foo2 = DbAgile::Fixtures::Assumptions::FooComparable.new(1)
    (foo1 <=> foo2).should == 0
    (foo1 == foo2).should == false
  end
  
end