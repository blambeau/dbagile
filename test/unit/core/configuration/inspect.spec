require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Configuration#inspect /" do

  describe "When no prefix is given" do
    let(:config_str){ %Q{config(:test){\n  uri "sqlite://test.db"\n}} }
    let(:config)    { Kernel.eval("DbAgile::" + config_str) }
    subject{ config.inspect }
    it{ should == config_str }
  end

  describe "When a specific prefix is given" do
    let(:config_str){ %Q{config(:test){\n  uri "sqlite://test.db"\n}} }
    let(:config)    { Kernel.eval("DbAgile::" + config_str) }
    subject{ config.inspect("Hello::") }
    it{ should == "Hello::" + config_str }
  end

end
  
