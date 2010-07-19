require 'dbagile/contract/robust/optimistic/data/table_driven'
require 'dbagile/contract/robust/optimistic/data/transaction_driven'
require 'dbagile/contract/robust/optimistic/schema/table_driven'
require 'dbagile/contract/robust/optimistic/schema/transaction_driven'
module DbAgile
  module Contract
    module Robust
      class Optimistic
        include DbAgile::Contract::Utils::Delegate
        include DbAgile::Contract::Robust::Helpers
        include DbAgile::Contract::Robust::Optimistic::Data::TableDriven
        include DbAgile::Contract::Robust::Optimistic::Data::TransactionDriven
        include DbAgile::Contract::Robust::Optimistic::Schema::TableDriven
        include DbAgile::Contract::Robust::Optimistic::Schema::TransactionDriven
      end # class Optimistic
    end # module Robust
  end # module Contract
end # module DbAgile
