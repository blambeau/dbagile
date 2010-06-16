require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/commands'
describe "::DbAgile::Commands::Main#prepare_command" do
  
  let(:source_file){ File.expand_path("../source_text.fxdb", __FILE__) }
  let(:command){ ::DbAgile::Commands::Main.new }
  subject{ command.prepare_command(arguments.split) }
  
  context "when called without arguments" do
    let(:arguments){ "" }
    specify{
      subject.should == command
      command.file.should be_nil
      command.uri.should be_nil
      command.env.should be_kind_of(DbAgile::Engine::ConsoleEnvironment)
    }
  end
  
  context "when called with all options" do
    let(:arguments){ "--file=#{source_file} --uri=sqlite://test.db" }
    specify{
      subject.should == command
      command.file.should == source_file
      command.uri.should == "sqlite://test.db"
      command.env.should be_kind_of(DbAgile::Engine::DslEnvironment)
    }
  end
  
  ["--uri=sqlite://test.db", "sqlite://test.db"].each do |args|
    context "when called with an uri only #{args}" do
      let(:arguments){ args }
      specify{
        subject.should == command
        command.file.should be_nil
        command.uri.should == "sqlite://test.db"
        command.env.should be_kind_of(DbAgile::Engine::ConsoleEnvironment)
      }
    end
  end
  
  ["--file=#{File.expand_path("../source_text.fxdb", __FILE__)}", "#{File.expand_path("../source_text.fxdb", __FILE__)}"].each do |args|
    context "when called with a file only #{args}" do
      let(:arguments){ args }
      specify{
        subject.should == command
        command.file.should == source_file
        command.uri.should be_nil
        command.env.should be_kind_of(DbAgile::Engine::DslEnvironment)
      }
    end
  end
  
  context "when called with a --trace-sql option" do
    let(:arguments){"--trace-sql"}
    specify{
      subject.should == command
      command.connection_options.should == {:trace_sql => true, :trace_only => false, :trace_buffer => STDOUT}
    }
  end
  
  context "when called with a --trace-only option" do
    let(:arguments){"--trace-only"}
    specify{
      subject.should == command
      command.connection_options.should == {:trace_sql => true, :trace_only => true, :trace_buffer => STDOUT}
    }
  end
  
  context "when called with --trace-sql and --output options" do
    let(:arguments){"--trace-sql --output=#{source_file}"}
    specify{
      subject.should == command
      command.connection_options[:trace_sql].should be_true
      command.connection_options[:trace_only].should be_false
      command.connection_options[:trace_buffer].should be_kind_of(IO)
    }
  end

end
