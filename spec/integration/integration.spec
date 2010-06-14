require File.expand_path('../../spec_helper', __FILE__)
require 'fileutils'
Dir[File.join(File.dirname(__FILE__), '**/*.fxdb')].each do |file|
  content = File.read(file)
  describe("Execution of #{file}") do

    let(:database){ 
      File.expand_path('../integration.db', __FILE__)
    }

    before {
      FileUtils.rm_rf(database)
      schema = File.read(File.join(File.dirname(__FILE__), 'commons.dba'))
      DbAgile::connect("sqlite://#{database}").execute(schema)
    }

    subject{
      lambda{ DbAgile::connect("sqlite://#{database}").execute(content) }
    }

    it{ should_not raise_error }
  end
end