require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::DslEnvironment#initialize" do
  
  context "when called with a source as a Proc" do
    let(:source) { lambda{ use :AgileTable } }
    subject{ DbAgile::Engine::DslEnvironment.new(source) }
    specify{
      subject.load_lines.should == [ CodeTree::parse{ (use :AgileTable) } ]
    }
  end
  
  context "when called with a source as a String" do
    let(:source) { "use :AgileTable" }
    subject{ DbAgile::Engine::DslEnvironment.new(source) }
    specify{
      subject.load_lines.should == [ CodeTree::parse{ (use :AgileTable) } ]
    }
  end
  
end