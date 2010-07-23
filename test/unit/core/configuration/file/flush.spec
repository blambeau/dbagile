require File.expand_path('../../../../fixtures', __FILE__)
require 'fileutils'
describe "DbAgile::Core::Configuration::File#inspect" do

  describe "On examples files" do
    Dir[File.expand_path('../*.dba', __FILE__)].each do |file|
      specify{ 
        begin
          config_file = DbAgile::Core::Configuration::File.new(file)
          output = File.join(File.dirname(__FILE__), "#{File.basename(file, '.dba')}.flush")
          config_file.flush(output)
          File.read(output).should == File.read(file)
        ensure
          FileUtils.rm_rf(output)
        end
      }
    end
  end

end
  
