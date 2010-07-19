module DbAgile
  module Contract
    module Utils
      module Full
        include DbAgile::Contract::Connection
        include DbAgile::Contract::Data::TableDriven
        include DbAgile::Contract::Data::TransactionDriven
        include DbAgile::Contract::Schema::TableDriven
        include DbAgile::Contract::Schema::TransactionDriven
      end # module Full
    end # module Utils
  end # module Contract
end # module DbAgile