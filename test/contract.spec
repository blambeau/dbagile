require File.expand_path('../spec_helper', __FILE__)
Dir[File.expand_path('../contract/**/*.spec', __FILE__)].each{|f| load(f)}
describe "DbAgile Contract specification" do
  
  let(:basic_values)      { DbAgile::Fixtures::basic_values       }
  let(:basic_values_tuple){ DbAgile::Fixtures::basic_values_tuple }
  let(:basic_values_keys) { DbAgile::Fixtures::basic_values_keys  }
  
  # Contract::Connection
  DbAgile::Fixtures::config_file.each do |config|

    describe "::DbAgile::Core::Connection on #{config.name}" do
      subject{ config.connect }
      it_should_behave_like("A Contract::Connection")
      if config.ping?
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
      end
    end

    describe "::DbAgile::Core::Transaction on #{config.name}" do
      subject{ DbAgile::Core::Transaction.new(config.connect) }
      it_should_behave_like("A Contract::Connection")
      if config.ping?
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
      end
    end
    
    if config.ping?
      
      describe "Result of dataset(Symbol) on #{config.name}" do
        subject{ config.connect.dataset(:basic_values) }
        it_should_behave_like("A Contract::Data::Dataset")
      end
      
      describe "Result of dataset(String) on #{config.name}" do
        subject{ config.connect.dataset("SELECT * FROM basic_values") }
        it_should_behave_like("A Contract::Data::Dataset")
      end
      
    end

  end # Contract::Connection
  
end  
