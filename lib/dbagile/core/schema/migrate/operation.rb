module DbAgile
  module Core
    module Schema
      module Migrate
        class Operation
          
          # The sub operations
          attr_reader :operations
        
          # Targetted relation variable
          attr_reader :relvar
          
          # Returns table name
          def table_name
            relvar.name
          end
          
          def initialize(relvar)
            unless relvar.kind_of?(DbAgile::Core::Schema::Logical::Relvar)
              raise ArgumentError, "Relvar expected for relvar, got #{relvar.class}"
            end
            @relvar = relvar
            @operations = []
          end
          
          # Returns kind of this operation
          def kind
            unqualified = DbAgile::RubyTools::class_unqualified_name(self.class).to_s
            unqualified.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1].to_sym
          end
          
          # Asserts that this operation supports sub operations
          def supports_sub_operation!(name)
            if self.kind_of?(Migrate::DropTable)
              raise DbAgile::AssumptionFailedError, "#{self.class} does not support sub operation #{name}"
            end
          end
          
          # Yields the block with each (subop_kind, operand) pair
          def each_sub_operation(&block)
            supports_sub_operation!(nil)
            operations.each{|op| block.call(op[0], op[1])}
          end
          
          # Create/alter an attribute
          def attribute(attribute)
            supports_sub_operation!(:attribute)
            operations << [:attribute, attribute]
          end

          # Create/alter a candidate key
          def candidate_key(ckey)
            supports_sub_operation!(:candidate_key)
            operations << [:candidate_key, ckey]
          end

          # Create/alter a foreign key
          def foreign_key(fkey)
            supports_sub_operation!(:foreign_key)
            operations << [:foreign_key, fkey]
          end

          # Create/alter an index
          def index(index)
            supports_sub_operation!(:index)
            operations << [:index, index]
          end
          
        end # class Operation
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
