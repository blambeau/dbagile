require File.expand_path('../../../../spec_helper', __FILE__)
require 'flexidb/commands'
describe "::FlexiDB::Commands::Main#prepare_command" do
  
  let(:command){ ::FlexiDB::Commands::Main.new }
  subject{ command.prepare_command(arguments.split) }
  
  context "when called without arguments" do
    let(:arguments){ "" }
    specify{
      subject.should == command
      command.file.should be_nil
      command.uri.should be_nil
      command.env.should be_kind_of(FlexiDB::Engine::ConsoleEnvironment)
    }
  end
  
  context "when called with all options" do
    let(:arguments){ "--file=FILE --uri=sqlite://test.db" }
    specify{
      subject.should == command
      command.file.should == "FILE"
      command.uri.should == "sqlite://test.db"
      command.env.should be_kind_of(FlexiDB::Engine::FileEnvironment)
    }
  end
  
  ["--uri=sqlite://test.db", "sqlite://test.db"].each do |args|
    context "when called with an uri only #{args}" do
      let(:arguments){ args }
      specify{
        subject.should == command
        command.file.should be_nil
        command.uri.should == "sqlite://test.db"
        command.env.should be_kind_of(FlexiDB::Engine::ConsoleEnvironment)
      }
    end
  end
  
  ["--file=file.fxdb", "file.fxdb"].each do |args|
    context "when called with a file only #{args}" do
      let(:arguments){ args }
      specify{
        subject.should == command
        command.file.should == "file.fxdb"
        command.uri.should be_nil
        command.env.should be_kind_of(FlexiDB::Engine::FileEnvironment)
      }
    end
  end
  
end
