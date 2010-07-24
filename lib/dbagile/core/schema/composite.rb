module DbAgile
  module Core
    module Schema
      class Composite < SchemaObject
        include Enumerable
      
        # Creates a composite instance with parts
        def initialize(composite_parts = _default_parts)
          unless composite_parts.kind_of?(Hash)
            raise ArgumentError, "Composite parts must be a hash, got #{composite_parts.inspect}" 
          end
          _install_parts(composite_parts)
        end
      
        ############################################################################
        ### Private interface
        ############################################################################
        attr_reader :composite_parts
        protected   :composite_parts
        private
      
        # Creates defaut parts hash
        def _default_parts
          {}
        end
      
        # Make installation of parts
        def _install_parts(parts)
          meth = _install_eigenclass_methods?
          parts.each_pair{|k, v|
            v.send(:parent=, self)
            if meth
              eigenclazz = (class << self; self; end)
              eigenclazz.send(:define_method, k){ @composite_parts[k] }
            end
          }
          @composite_parts = parts
        end
      
        # Installs eigenclass methods on parts provided at construction
        def _install_eigenclass_methods?
          false
        end
      
        ############################################################################
        ### Public interface
        ############################################################################
        public
      
        # Yields the block with each part in turn
        def each(&block)
          @composite_parts.values.each(&block)
        end
      
        ############################################################################
        ### SchemaObject
        ############################################################################
      
        # @see DbAgile::Core::SchemaObject
        def empty?(recurse = true)
          if recurse
            parts.all?{|p| p.composite? && p.empty?}
          else
            @composite_parts.empty?
          end
        end
      
        # @see DbAgile::Core::SchemaObject
        def part_keys
          @composite_parts.keys
        end
      
        # @see DbAgile::Core::SchemaObject
        def parts
          @composite_parts.values
        end
      
        # @see DbAgile::Core::SchemaObject
        def [](name)
          @composite_parts[name]
        end
      
        # @see DbAgile::Core::SchemaObject
        def []=(name, part)
          if @composite_parts.key?(name)
            raise ArgumentError, "A part already exists with name '#{name}'" 
          end
          @composite_parts[name] = part
          part.send(:parent=, self)
          part
        end
      
        ############################################################################
        ### About IO
        ############################################################################
      
        # @see DbAgile::Core::SchemaObject
        def to_yaml(opts = {})
          YAML::quick_emit(self, opts){|out|
            out.map("tag:yaml.org,2002:map") do |map|
              part_keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.each{|k|
                map.add(k.to_s, self[k])
              }
            end
          }
        end
      
        ############################################################################
        ### Equality and hash code
        ############################################################################
      
        # @see DbAgile::Core::SchemaObject
        def ==(other)
          return nil unless other.kind_of?(self.class)
          (@composite_parts == other.composite_parts)
        end
      
        # @see DbAgile::Core::SchemaObject
        def hash
          @composite_parts.hash
        end
      
        # @see DbAgile::Core::SchemaObject
        def dup
          dup_parts = {}
          @composite_parts.each_pair{|name, part| dup_parts[name] = part.dup}
          self.class.new(dup_parts)
        end
      
      end # class Composite
    end # module Schema
  end # module Core
end # module DbAgile