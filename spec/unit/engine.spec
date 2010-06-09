require File.expand_path('../../spec_helper', __FILE__)
require 'flexidb/engine'
describe 'FlexiDB::Engine' do
  
  FlexiDB::Engine.new.each_command do |cmd|
    context "#{cmd.class} is valid" do
      subject{ lambda{ cmd.class.check } }
      it{ should_not raise_error }
    end
  end
  
end
