module DbAgile
  module Contract
    module Delegate
      
      [ ::DbAgile::Contract::ConnectionDriven, 
        ::DbAgile::Contract::TableDriven, 
        ::DbAgile::Contract::TransactionDriven ].each do |contract|
          
        contract.instance_methods(false).each do |meth|
          module_eval <<-EOF
            def #{meth}(*args, &block)
              delegate.#{meth}(*args, &block)
            end
          EOF
        end

      end
    
    end # module Delegate
  end # module Contract
end # module DbAgile