require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Configuration#inspect" do

  Dir[File.expand_path('../*.dba', __FILE__)].each do |file|
    specify{ 
      config_str = File.read(file)
      config = Kernel.eval(config_str)
      config.name.should == File.basename(file, '.dba').to_sym
      if config.name == :complex3
        pending("Config.inspect should support complex options") { config.inspect.should == config_str } 
      else
        config.inspect.should == config_str
      end
    }
  end

end
  
