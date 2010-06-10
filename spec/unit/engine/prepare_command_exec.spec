require File.expand_path('../../../spec_helper', __FILE__)
require 'flexidb/engine'
describe "DbAgile::Engine#prepare_command_exec" do
  
  let(:engine){ DbAgile::Engine.new }
  
  context("when called on an unexisting command") do
    subject{ lambda{ engine.prepare_command_exec(:not_a_command, []) } }
    specify{ subject.should raise_error(ArgumentError) }
  end
  
  context("when called on an command without arguments") do
    subject{ engine.prepare_command_exec(:quit, []) }
    specify{ 
      result = subject
      result[0].name.should == "quit"
      result[1].should == :execute_1
      result[2].should == []
    }
  end
  
  context("when called on an command with arguments") do
    subject{ engine.prepare_command_exec(:sql, ["SELECT * FROM TABLE"]) }
    specify{ 
      result = subject
      result[0].name.should == "sql"
      result[1].should == :execute_1
      result[2].should == ["SELECT * FROM TABLE"]
    }
  end
  
end
