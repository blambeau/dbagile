module DbAgile
  module Contract
    module Delegate
      
      DbAgile::Contract::Full.instance_methods(true).each do |meth|
        module_eval <<-EOF
          def #{meth}(*args, &block)
            delegate.#{meth}(*args, &block)
          end
        EOF
      end
    
    end # module Delegate
  end # module Contract
end # module DbAgile