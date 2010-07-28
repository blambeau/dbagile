require File.expand_path('../spec_helper', __FILE__)
dbagile_load_all_subspecs(__FILE__)
describe "DbAgile::Contract /" do
  
  let(:basic_values)        { DbAgile::Fixtures::basic_values         }
  let(:basic_values_heading){ DbAgile::Fixtures::basic_values_heading }
  let(:basic_values_tuple)  { DbAgile::Fixtures::basic_values_tuple   }
  let(:basic_values_keys)   { DbAgile::Fixtures::basic_values_keys    }
  
  DbAgile::Fixtures::environment.each_database do |database|
    next if database.name == :unexisting
    unless database.ping?
      puts "skipping #{database.name} (no ping)"
      next
    end
  
    describe "on #{database.name} /" do
    
      before(:each){ @connection = database.connect   }
      after(:each) { @connection.disconnect if @connection }
      let(:conn)   { @connection }
      let(:trans)  { DbAgile::Core::Transaction.new(conn) }
  
      describe "::DbAgile::Core::Connection" do
        subject{ conn }
        it_should_behave_like("A Contract::Connection")
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
        if /robust/ =~ database.name.to_s
          it_should_behave_like("A robust Contract::Data::TableDriven")
          it_should_behave_like("A robust Contract::Schema::TableDriven")
        end
      end

      describe "::DbAgile::Core::Transaction" do
        subject{ trans  }
        it_should_behave_like("A Contract::Connection")
        it_should_behave_like("A Contract::Data::TableDriven")
        it_should_behave_like("A Contract::Data::TransactionDriven")
        it_should_behave_like("A Contract::Schema::TableDriven")
        it_should_behave_like("A Contract::Schema::TransactionDriven")
        if /robust/ =~ database.name.to_s
          it_should_behave_like("A robust Contract::Data::TableDriven")
          it_should_behave_like("A robust Contract::Data::TransactionDriven")
          it_should_behave_like("A robust Contract::Schema::TableDriven")
          it_should_behave_like("A robust Contract::Schema::TransactionDriven")
        end
      end

      describe "Result of dataset(Symbol)" do
        subject{ conn.dataset(:basic_values) }
        it_should_behave_like("A Contract::Data::Dataset")
      end
  
      describe "Result of dataset(String)" do
        subject{ conn.dataset("SELECT * FROM basic_values") }
        it_should_behave_like("A Contract::Data::Dataset")
      end

      describe "Result of direct_sql('SELECT ...')" do
        subject{ trans.direct_sql("SELECT * FROM basic_values") }
        it_should_behave_like("A Contract::Data::Dataset")
      end

    end # on #{database.name}
  end # each database
  
end # describe DbAgile::Contract
