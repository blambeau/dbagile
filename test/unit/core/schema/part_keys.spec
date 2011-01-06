require File.expand_path('../fixtures', __FILE__)
if RUBY_VERSION >= "1.9"
  describe "DbAgile::Core::Schema part_keys on composites" do

    let(:sap) { DbAgile::Fixtures::Core::Schema::schema(:suppliers_and_parts) }
    
    it "should respect yaml file ordering" do
      sap.logical.part_keys.should == [:SUPPLIERS, :PARTS, :SUPPLIES]
    end
  
  end 
end
