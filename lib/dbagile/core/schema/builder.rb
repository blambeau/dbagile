require 'dbagile/core/schema/builder/helpers'
require 'dbagile/core/schema/builder/hash_factory'
module DbAgile
  module Core
    class Schema
      class Builder
        include Builder::Helpers
        include Builder::HashFactory
        
        # Call stack
        attr_accessor :stack
        
        # Creates a builder instance
        def initialize
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
        def _push(section, object)
          stack.push([section, object])
          if block_given?
            yield
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
              s = symbolized_hash!(hash, 1, [ :logical, :physical ])
              self.send(s.keys[0], s.values[0])
            when :logical
              symbolized_hash!(hash).each_pair{|relvar_name, relvar_def|
                relvar(relvar_name, relvar_def)
              }
            when :heading
              symbolized_hash!(hash).each_pair{|attr_name, attr_def|
                attribute(attr_name, attr_def)
              }
            when :constraints
              symbolized_hash!(hash).each_pair{|c_name, c_def|
                constraint(c_name, c_def)
              }
            when :physical
              s = symbolized_hash!(hash, nil, [ :indexes ])
              self.send(s.keys[0], s.values[0])
            when :indexes
              symbolized_hash!(hash).each_pair{|index_name, index_def|
                index(index_name, index_def)
              }
            else
              symbolized_hash!(hash).each_pair{|k, v|
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
          _push(:logical, _peek(:root).logical, &block)
        end
        
        # Starts a relvar section
        def relvar(name, hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          relvar = (_peek(:logical)[symbolize_name(name)] ||= build_relvar(name))
          _push(:relvar, relvar, &block)
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
          _peek(:heading)[symbolize_name(name)] = build_attribute(name, definition)
        end
        
        # Adds a constraint to current relvar
        def constraint(name, definition)
          _peek(:constraints)[symbolize_name(name)] = build_constraint(name, definition)
        end
        
        ############################################################################
        ### Physical sections
        ############################################################################
        
        # Starts the physical section and yields
        def physical(hash = nil, &block)
          block = lambda{ _natural(hash) } unless block
          _push(:physical, _peek(:root).physical, &block)
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
          _peek(:indexes)[symbolize_name(name)] = build_index(name, definition)
        end
        
      end # class Builder
    end # class Schema
  end # module Core
end # module DbAgile
