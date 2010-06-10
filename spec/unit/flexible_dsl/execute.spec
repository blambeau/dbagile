require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::FlexibleDSL#execute" do

  let(:dsl){ DbAgile::FlexibleDSL.new(nil) }

  describe "underlying constant resolving mechanism" do
    let(:exec){ dsl.send(:execute){ FlexibleTable } }
    specify("should resolve constants correctly") do
      exec.should == DbAgile::Plugin::FlexibleTable
    end
    specify("should clean Object API after that") do
      exec.should == DbAgile::Plugin::FlexibleTable
      lambda{ FlexibleTable }.should raise_error(NameError)
    end
  end
  
end