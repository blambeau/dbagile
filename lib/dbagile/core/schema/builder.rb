require 'dbagile/core/schema/coercion'
require 'dbagile/core/schema/builder/concept_factory'
module DbAgile
  module Core
    class Schema
      class Builder
        include Schema::Coercion
        # include Builder::HashFactory
        include Builder::ConceptFactory
        
        # Call stack
        attr_accessor :stack
        
        # Creates a builder instance
        def initialize(schema = Schema.new)
          @stack = [ [:root, Schema.new ] ]
        end
        
        ############################################################################
        ### About result
        ############################################################################
        
        # Dumps as a Schema instance
        def _dump
          _peek(:root)
        end
        
        ############################################################################
        ### About the call stack
        ############################################################################
        
        # Push a hash on the stack
        def _push(section, object, &block)
          stack.push([section, object])
          if block
            DbAgile::RubyTools::optional_args_block_call(block, [ object ])
            _pop
          end
          object
        end
        
        # Pops a hash from the stack
        def _pop
          stack.pop
        end
        
        # Returns top value of the stack
        def _peek(section = nil)
          unless section.nil? 
            if stack.empty? or not(stack.last[0] == section)
              invalid!("expected to be in #{section}, but was #{stack.last[0]}")
            end
          end
          stack.last[1]
        end
        
        # Applies natural rules according to current section
        def _natural(hash)
          case section = stack.last[0]
            when :root
              s = coerce_symbolized_hash(hash)
              self.send(s.keys[0], s.values[0])
            when :logical
              coerce_symbolized_hash(hash).each_pair{|relvar_name, relvar_def|
                relvar(relvar_name, relvar_def)
              }
            when :heading
              coerce_symbolized_hash(hash).each_pair{|attr_name, attr_def|
                attribute(attr_name, attr_def)
              }
            when :constraints
              coerce_symbolized_hash(hash).each_pair{|c_name, c_def|
                constraint(c_name, c_def)
              }
            when :physical
              coerce_symbolized_hash(hash).each_pair{|name, defn|
                self.send(name, defn)
              }
            when :indexes
              coerce_symbolized_hash(hash).each_pair{|index_name, index_def|
                index(index_name, index_def)
              }
            else
              coerce_symbolized_hash(hash).each_pair{|k, v|
                invalid!("No such section #{k}") unless self.respond_to?(k)
                self.send(k, v)
              }
          end
        end
        
        ############################################################################
        ### Logical sections
        ############################################################################
        
        # Starts the logical section and yields
        def logical(hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          logical = (_peek(:root)[:logical] ||= build_logical)
          _push(:logical, logical, &block)
        end
        
        # Starts a relvar section
        def relvar(name, hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          name = coerce_relvar_name(name)
          relvar = (_peek(:logical)[name] ||= build_relvar(name))
          _push(:relvar, relvar, &block)
        rescue SByC::TypeSystem::CoercionError => ex
          invalid!("Invalid relvar definition (#{name}): #{ex.message}")
        end
        
        # Starts a heading section
        def heading(hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          heading = (_peek(:relvar)[:heading] ||= build_heading)
          _push(:heading, heading, &block)
        end
        
        # Starts a constraints section
        def constraints(hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          cs = (_peek(:relvar)[:constraints] ||= build_constraints)
          _push(:constraints, cs, &block)
        end
        
        ### 
        
        # Adds an attribute to current heading
        def attribute(name, definition)
          name, defn = coerce_attribute_name(name), coerce_attribute_definition(definition)
          _peek(:heading)[name] = build_attribute(name, defn)
        end
        
        # Adds a constraint to current relvar
        def constraint(name, definition)
          name, defn = coerce_constraint_name(name), coerce_constraint_definition(definition)
          _peek(:constraints)[name] = build_constraint(name, defn)
        end
        
        ############################################################################
        ### Physical sections
        ############################################################################
        
        # Starts the physical section and yields
        def physical(hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          physical = (_peek(:root)[:physical] ||= build_physical)
          _push(:physical, physical, &block)
        end
        
        # Starts the indexes section and yields
        def indexes(hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          indexes = (_peek(:physical)[:indexes] ||= build_indexes)
          _push(:indexes, indexes, &block)
        end
        
        ### 
        
        # Adds an index to indexes
        def index(name, definition)
          name, defn = coerce_index_name(name), coerce_index_definition(definition)
          _peek(:indexes)[name] = build_index(name, defn)
        rescue SByC::TypeSystem::CoercionError => ex
          invalid!("Invalid index definition (#{name}): #{ex.message}")
        end
        
      end # class Builder
    end # class Schema
  end # module Core
end # module DbAgile
