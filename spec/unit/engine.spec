require File.expand_path('../../spec_helper', __FILE__)
require 'flexidb/engine'
describe 'DbAgile::Engine' do
  
  DbAgile::Engine.new(nil).each_command do |cmd|
    context "#{cmd.class} is valid" do
      subject{ lambda{ cmd.class.check } }
      it{ should_not raise_error }
    end
  end
  
end
