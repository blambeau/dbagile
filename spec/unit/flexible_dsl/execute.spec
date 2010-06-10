require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::FlexibleDSL#execute" do

  let(:dsl){ DbAgile::FlexibleDSL.new(nil) }

  describe "underlying constant resolving mechanism" do
    let(:exec){ dsl.send(:execute){ AgileTable } }
    specify("should resolve constants correctly") do
      exec.should == DbAgile::Plugin::AgileTable
    end
    specify("should clean Object API after that") do
      exec.should == DbAgile::Plugin::AgileTable
      lambda{ AgileTable }.should raise_error(NameError)
    end
  end
  
end