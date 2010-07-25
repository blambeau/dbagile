require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema's sanity /" do
  
  let(:schema){ DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }
  
  it "all objects should looking same as their duplicated" do
    schema.each{|p,parent| 
      p.dup.look_same_as?(p).should == true
    }
  end
  
  it "no object be the same object when duplicated" do
    schema.each{|p,parent| p.dup.object_id.should_not == p.object_id}
  end
  
  it "no object should be equal as its duplicated" do
    schema.each{|p,parent| p.dup.should_not == p}
  end
  
  it "should be sane when loaded" do
    lambda{ schema.send(:_sanity_check, schema) }.should_not raise_error
  end
  
  it "should stay sane after dup" do
    lambda{ 
      duplicated = schema.dup
      duplicated.send(:_sanity_check, duplicated) 
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