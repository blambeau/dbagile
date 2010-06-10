require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::DslEnvironment#load_lines" do
  
  let(:source) {
    lambda{
      use :AgileTable
      insert :table, {:id => 12}
      display :table
    }
  }
  let(:env){ DbAgile::Engine::DslEnvironment.new(source) }
  subject{ env.load_lines }
  
  it{ should == [
    ['use',     [:AgileTable]],
    ['insert',  [:table, {:id => 12}]],
    ['display', [:table]]
  ]}
  
end