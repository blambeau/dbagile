require File.expand_path('../../fixtures', __FILE__)
describe "::DbAgile::Plugin.with_options" do
  
  let(:subClass){ Class.new(::DbAgile::Plugin) }
  
  context "when called on a subclass" do
    subject{ subClass[:hello => "world"] }
    it{ should be_kind_of(subClass) }
    specify{ subject.options.should == {:hello => "world"}}
  end
  
end