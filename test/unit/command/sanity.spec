require File.expand_path('../../fixtures', __FILE__)
describe "command sanity /" do
  
  DbAgile::Command::each_subclass{|cmd|
    describe "#{cmd.command_name}" do
      
      it "should have a summary" do
        cmd.summary.should_not be_nil
        cmd.summary.strip.should_not be_empty
      end
      
      unless cmd.command_name == "dba"

        it "should have a usage" do
          cmd.usage.should =~ /^Usage: dba #{cmd.command_name}/
        end
      
      else
        
        it "should have the description" do
          cmd.description.should =~ /blambeau.github.com/
        end
        
      end
      
    end
  }
  
end