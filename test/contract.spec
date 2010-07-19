require File.expand_path('../spec_helper', __FILE__)
Dir[File.expand_path('../contract/**/*.spec', __FILE__)].each{|f| load(f)}
describe "DbAgile Contract specification" do
  
  let(:basic_values)      { DbAgile::Fixtures::basic_values       }
  let(:basic_values_tuple){ DbAgile::Fixtures::basic_values_tuple }
  let(:basic_values_keys) { DbAgile::Fixtures::basic_values_keys  }
  
  # Contract::Connection
  DbAgile::Fixtures::config_file.each do |configuration|
    next unless configuration.ping?
    
    let(:config)    { configuration         }
    let(:connection){ config.connect        }
    after(:each)    { connection.disconnect }
    
    describe "::DbAgile::Core::Connection on #{configuration.name}" do
      subject{ connection }
      it_should_behave_like("A Contract::Connection")
      it_should_behave_like("A Contract::Data::TableDriven")
      it_should_behave_like("A Contract::Schema::TableDriven")
    end
  
    describe "::DbAgile::Core::Transaction on #{configuration.name}" do
      subject{ DbAgile::Core::Transaction.new(connection) }
      it_should_behave_like("A Contract::Connection")
      it_should_behave_like("A Contract::Data::TableDriven")
      it_should_behave_like("A Contract::Schema::TableDriven")
    end
  
    describe "Result of dataset(Symbol) on #{configuration.name}" do
      subject{ connection.dataset(:basic_values) }
      it_should_behave_like("A Contract::Data::Dataset")
    end
    
    describe "Result of dataset(String) on #{configuration.name}" do
      subject{ connection.dataset("SELECT * FROM basic_values") }
      it_should_behave_like("A Contract::Data::Dataset")
    end

  end # Contract::Connection
  
end  
