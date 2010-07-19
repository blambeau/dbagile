require File.expand_path('../spec_helper', __FILE__)
Dir[File.expand_path('../contract/**/*.spec', __FILE__)].each{|f| load(f)}
describe "DbAgile Contract specification" do
  
  # Contract::Connection
  DbAgile::Fixtures::config_file.each do |config|

    describe "::DbAgile::Core::Connection" do
      subject{ config.connect }
      it_should_behave_like("A Contract::Connection")
      if config.ping?
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
      end
    end

    describe "::DbAgile::Core::Transaction" do
      subject{ DbAgile::Core::Transaction.new(config.connect) }
      it_should_behave_like("A Contract::Connection")
      if config.ping?
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
      end
    end

  end # Contract::Connection
  
end  
