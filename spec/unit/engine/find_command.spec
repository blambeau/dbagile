require File.expand_path('../../../spec_helper', __FILE__)
require 'dbagile/engine'
describe "DbAgile::Engine#find_command" do
  
  let(:engine){ DbAgile::Engine.new }
  
  context "when called on unexisting command" do
    subject{ lambda{ engine.find_command(:not_a_command) } }
    it{ should raise_error(DbAgile::Engine::NoSuchCommandError) }
  end
  
  context "when called an existing command without block and a symbol" do
    subject{ engine.find_command(:quit) }
    it{ should be_kind_of(DbAgile::Engine::Command::Quit) }
  end
  
  context "when called an existing command without block and a string" do
    subject{ engine.find_command('\q') }
    it{ should be_kind_of(DbAgile::Engine::Command::Quit) }
  end
  
  context "when called an existing command with a block" do
    subject{ engine.find_command(:quit){|cmd| "hello #{cmd.name}"}}
    it{ should == "hello quit" }
  end
  
end
