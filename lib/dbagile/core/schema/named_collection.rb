module DbAgile
  module Core
    class Schema
      class NamedCollection
        include Enumerable
        
        # Collection kind
        attr_reader :kind
        
        # Objects by name (Hash)
        attr_reader :objects
        
        # Creates a collection instance
        def initialize(kind)
          @kind = kind
          @objects = {}
        end
        
        # Delegated to objects (values)
        def each(&block)
          objects.values.each(&block)
        end
        
        # Returns names
        def names
          objects.keys
        end
        
        # Returns an object by name
        def [](name)
          objects[name]
        end
        
        # Sets an object
        def []=(name, object)
          objects[name] = object
        end
        
        # Checks if this collection is empty
        def empty?
          objects.empty?
        end
        
        # Delegation pattern on YAML flushing
        def to_yaml(opts = {})
          DbAgile::Core::Schema::Coercion::unsymbolize_hash(objects).to_yaml(opts)
        end
        
        # Delegate pattern on minus
        def minus(other, builder)
          unless other.kind_of?(NamedCollection) and other.kind == kind
            raise ArgumentError, "NamedCollection(#{kind}) expected" 
          end
          builder.send(kind){|builder_object|
            names.each{|name|
              unless other[name] == self[name]
                builder_object[name] = self[name]
              end
            }
          }
        end
        
        # Compares with another attribute
        def ==(other)
          return nil unless other.kind_of?(NamedCollection)
          (self.kind == other.kind) and (self.objects == other.objects)
        end
          
      end # class NamedCollection
    end # class Schema
  end # module Core
end # module DbAgile