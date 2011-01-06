module DbAgile
  module Core
    module Schema
      module Migrate
        class Operation
          
          # The sub operations
          attr_reader :operations
        
          # Targetted relation variable/view
          attr_reader :rel_object
          alias :relvar :rel_object
          alias :relview :rel_object
          
          # Returns table name
          def table_name
            relvar.name
          end
          
          def initialize(rel_object)
            unless rel_object.relvar? or rel_object.relview?
              raise ArgumentError, "Relvar expected for rel_object, got #{rel_object.class}"
            end
            @rel_object = rel_object
            @operations = []
          end
          
          # Returns kind of this operation
          def kind
            unqualified = DbAgile::RubyTools::class_unqualified_name(self.class).to_s
            unqualified.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1].to_sym
          end
          
          ##########################################################################
          ### Execution feedback
          ##########################################################################
          
          # Mark an object as upgraded
          def staged!(obj = relvar)
            obj.status = case obj.status
              when Schema::TO_CREATE, Schema::CREATED
                Schema::CREATED
              when Schema::TO_ALTER, Schema::ALTERED
                Schema::ALTERED
              when Schema::TO_DROP, Schema::DROPPED
                Schema::DROPPED
              when Schema::NO_CHANGE
                Schema::NO_CHANGE
              else
                status_str = obj.status.to_s.upcase
                raise DbAgile::AssumptionFailedError, "Unexpected staged! source status #{status_str} on #{obj}"
            end
          end
          
          # Mark an object as not being staged
          def not_staged!(obj = relvar)
            obj.status = case obj.status
              when Schema::TO_CREATE
                Schema::DEFERED
              when Schema::TO_ALTER
                Schema::DEFERED
              when Schema::TO_DROP
                Schema::DEFERED
              when Schema::DEFERED
                Schema::DEFERED
              when Schema::NO_CHANGE
                Schema::NO_CHANGE
              else
                status_str = obj.status.to_s.upcase
                raise DbAgile::AssumptionFailedError, "Unexpected staged! source status #{status_str} on #{obj}"
            end
          end
          
          ##########################################################################
          ### About sub operations
          ##########################################################################
          
          # Asserts that this operation supports sub operations
          def supports_sub_operation?(name = nil)
            !self.kind_of?(Migrate::DropTable)
          end
          
          # Asserts that this operation supports sub operations
          def supports_sub_operation!(name)
            unless supports_sub_operation?(name)
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
          
          # Converts operations to simili SQL
          def ops_to_sql92(ops)
            ops.collect{|op|
              kind, operand = op
              case kind
                when :attribute
                  "COLUMN #{operand.name} #{operand.domain}"
                when :candidate_key
                  "CANDIDATE KEY #{operand.name})"
                when :foreign_key
                  "FOREIGN KEY #{operand.name}"
                when :index
                  "INDEX #{operand.name}"
                else
                  raise DbAgile::AssumptionFailedError, "Unexpected operation kin #{kind}"
              end
            }.join(';')
          end
          
        end # class Operation
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
