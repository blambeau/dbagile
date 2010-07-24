module DbAgile
  module Core
    class SchemaObject
      class Composite < SchemaObject
        include Enumerable
        
        # Creates a composite instance with parts
        def initialize(composite_parts = {}, install_methods = false)
          raise ArgumentError, "Composite parts must be a hash" unless composite_parts.kind_of?(Hash)
          @composite_parts = composite_parts
          _install_methods(composite_parts) if install_methods
        end
        
        def _install_methods(composite_parts)
          composite_parts.each_pair{|k, v|
            (class << self; self; end).send(:define_method, k){
              @composite_parts[k]
            }
          }
        end
        
        ############################################################################
        ### Public interface
        ############################################################################
        
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
          dup = self.class.new
          @composite_parts.each_pair{|name, part| dup[name] = part.dup}
          dup
        end

        attr_reader :composite_parts
        protected   :composite_parts
        private     :_install_methods
      end # class Coposite
    end # class SchemaObject
  end # module Core
end # module DbAgile