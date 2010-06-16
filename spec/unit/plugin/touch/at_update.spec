require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::Touch#at_update?" do
  
  let(:touch){ DbAgile::Plugin::Touch.new(nil, options) }
  subject{ touch.at_update? }
  
  context "when called on default options" do
    let(:options){ Hash.new }
    it{ should be_true }
  end
  
  context "when with :at => :insert" do
    let(:options){ {:at => :insert} }
    it{ should be_false }
  end
  
  context "when with :at => :update" do
    let(:options){ {:at => :update} }
    it{ should be_true }
  end
  
  context "when with :at => :both" do
    let(:options){ {:at => :both} }
    it{ should be_true }
  end
  
end