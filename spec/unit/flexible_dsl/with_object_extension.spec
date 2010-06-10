if RUBY_VERSION < "1.9"
  require File.expand_path('../../../spec_helper', __FILE__)
  describe "DbAgile::FlexibleDSL#with_object_extension" do
  
    let(:dsl){ DbAgile::FlexibleDSL.new(nil) }
  
    specify "it correctly resolves constants" do
      dsl.with_object_extension do
        AgileTable.should == ::DbAgile::Plugin::AgileTable
      end
    end

    specify "it cleans the object method after that" do
      dsl.with_object_extension do AgileTable end
      lambda{ AgileTable }.should raise_error(NameError)
    end
  
  end
end