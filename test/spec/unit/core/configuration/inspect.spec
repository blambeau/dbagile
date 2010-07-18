require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Configuration#inspect" do

  describe "On examples file and DbAgile:: prefix" do
    Dir[File.expand_path('../*.dba', __FILE__)].each do |file|
      specify{ 
        config_str = File.read(file)
        config = Kernel.eval(config_str)
        config.name.should == File.basename(file, '.dba').to_sym
        config.inspect("DbAgile::").should == config_str
      }
    end
  end

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
  
