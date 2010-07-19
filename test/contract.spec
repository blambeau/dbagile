require File.expand_path('../spec_helper', __FILE__)
dbagile_load_all_subspecs(__FILE__)
describe "DbAgile Contract specification" do
  
  let(:basic_values)      { DbAgile::Fixtures::basic_values       }
  let(:basic_values_tuple){ DbAgile::Fixtures::basic_values_tuple }
  let(:basic_values_keys) { DbAgile::Fixtures::basic_values_keys  }
  
  DbAgile::Fixtures::environment.each_config do |configuration|
    next unless configuration.ping?
    DbAgile::Fixtures::environment.with_connection(configuration) do |connection|
      let(:config){ configuration }
      let(:conn)  { connection    }
      let(:trans) { DbAgile::Core::Transaction.new(connection) }
    
      describe "::DbAgile::Core::Connection on #{configuration.name}" do
        subject{ conn }
        it_should_behave_like("A Contract::Connection")
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
      end
  
      describe "::DbAgile::Core::Transaction on #{configuration.name}" do
        subject{ trans  }
        it_should_behave_like("A Contract::Connection")
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Data::TransactionDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
        it_should_behave_like("A Contract::Schema::TransactionDriven")
      end
  
      describe "Result of dataset(Symbol) on #{configuration.name}" do
        subject{ conn.dataset(:basic_values) }
        it_should_behave_like("A Contract::Data::Dataset")
      end
    
      describe "Result of dataset(String) on #{configuration.name}" do
        subject{ conn.dataset("SELECT * FROM basic_values") }
        it_should_behave_like("A Contract::Data::Dataset")
      end

      describe "Result of direct_sql('SELECT ...') on #{configuration.name}" do
        subject{ trans.direct_sql("SELECT * FROM basic_values") }
        it_should_behave_like("A Contract::Data::Dataset")
      end

    end
  end
  
end  
