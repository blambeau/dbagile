module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          class Operation
            
            # Returns kind of this operation
            def kind
              unqualified = DbAgile::RubyTools::class_unqualified_name(self.class).to_s
              unqualified.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1].to_sym
            end
            
            # Is it a create table operation?
            def create_table?
              self.kind_of?(Stage::CreateTable)
            end
            
            # Is it an expand table operation?
            def expand_table?
              self.kind_of?(Stage::ExpandTable)
            end
            
            # Is it an collapse table operation?
            def collapse_table?
              self.kind_of?(Stage::CollapseTable)
            end
            
            # Is it a drop table operation?
            def drop_table?
              self.kind_of?(Stage::DropTable)
            end
            
            # Returns table name
            def table_name
              unless self.respond_to?(:relation_variable)
                raise DbAgile::AssumptionFailedError, "#{self.class} has no relation variable"
              end
              relation_variable.name
            end
            
            # Asserts that this operation supports sub operations
            def supports_sub_operation!(name)
              unless self.respond_to?(:operations)
                raise DbAgile::AssumptionFailedError, "#{self.class} does not support sub operation #{name}"
              end
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
        end # module Stage
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/computations/stage/create_table'
require 'dbagile/core/schema/computations/stage/drop_table'
require 'dbagile/core/schema/computations/stage/expand_table'
require 'dbagile/core/schema/computations/stage/collapse_table'
