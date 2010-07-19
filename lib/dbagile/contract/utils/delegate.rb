module DbAgile
  module Contract
    module Utils
      module Delegate
      
        DbAgile::Contract::Utils::Full.instance_methods(true).each do |meth|
          module_eval <<-EOF
            def #{meth}(*args, &block)
              delegate.#{meth}(*args, &block)
            end
          EOF
        end
    
      end # module Delegate
    end # module Utils
  end # module Contract
end # module DbAgile