require File.expand_path('../../../../spec_helper', __FILE__)
require 'flexidb/engine'
describe "DbAgile::Engine::Command#check" do
  
  let(:valid_command){
    c = Class.new(DbAgile::Engine::Command)
    c.instance_eval{
      names "c1"
      signature{}
      synopsis "synopsis"
    }
    c
  }

  let(:missing_name){
    c = Class.new(DbAgile::Engine::Command)
    c.instance_eval{
      signature{}
      synopsis "synopsis"
    }
    c
  }

  let(:missing_signature){
    c = Class.new(DbAgile::Engine::Command)
    c.instance_eval{
      names "c1"
      synopsis "synopsis"
    }
    c
  }
  
  let(:missing_synopsis){
    c = Class.new(DbAgile::Engine::Command)
    c.instance_eval{
      names "c1"
      signature{}
    }
    c
  }
  
  context "when called on a valid command" do
    subject{ lambda{ valid_command.check } }
    it{ should_not raise_error }
  end
  
  context "when called on a command without name" do
    subject{ lambda{missing_name.check} }
    it{ should raise_error(RuntimeError) }
  end
  
  context "when called on a command without signature" do
    subject{ lambda{missing_signature.check} }
    it{ should raise_error(RuntimeError) }
  end
  
  context "when called on a command without synopsis" do
    subject{ lambda{missing_synopsis.check} }
    it{ should raise_error(RuntimeError) }
  end
  
end
