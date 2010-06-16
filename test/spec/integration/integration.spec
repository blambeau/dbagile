require File.expand_path('../../spec_helper', __FILE__)
require 'fileutils'
Dir[File.join(File.dirname(__FILE__), '**/*.fxdb')].each do |file|
  content = File.read(file)
  describe("Execution of #{file}") do

    let(:database){  File.expand_path('../integration.db', __FILE__) }
    let(:uri){ "sqlite://#{database}" }

    specify{ 
      FileUtils.rm_rf(database)
      schema = File.read(File.join(File.dirname(__FILE__), 'commons.dba'))
      engine = ::DbAgile::Engine.new
      engine.connect(uri).should be_kind_of(DbAgile::Core::Connection)
      engine.execute(schema)
      engine.connect(uri)
      engine.execute(content)
    }
  end

end