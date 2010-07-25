require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema's sanity /" do
  
  let(:schema){ DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }
  
  it "should equal itself when duplicated while not being same object" do
    dup = schema.dup
    dup.should == schema
    dup.object_id.should_not == schema.object_id
  end
  
  it "all objects should stay equal when duplicated" do
    schema.each{|p,parent| p.dup.should == p}
  end
  
  it "no objects should stay exactly the same when duplicated" do
    schema.each{|p,parent| p.dup.object_id.should_not == p.object_id}
  end
  
  it "should be sane when loaded" do
    lambda{ schema.send(:_sanity_check, schema) }.should_not raise_error
  end
  
  it "should stay sane after dup" do
    lambda{ 
      schema.send(:_sanity_check, schema)
      schema.dup.send(:_sanity_check, schema) 
      schema.send(:_sanity_check, schema)
    }.should_not raise_error
  end
  
  it "should not share objects when duplicated" do
    ids = schema.collect{|p, parent| p.object_id}
    dups = schema.dup.collect{|p, parent| p.object_id}
    ids.size.should == dups.size
    (ids & dups).should be_empty
  end
  
end