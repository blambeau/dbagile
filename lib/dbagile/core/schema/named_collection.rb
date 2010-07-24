module DbAgile
  module Core
    class Schema
      #
      # Helper module for implementing a brick which is a simple collection of 
      # named sub bricks.
      #
      module NamedCollection
        include Enumerable
        
        # Sub bricks, by name
        attr_accessor :sub_bricks
        
        ############################################################################
        ### Public interface
        ############################################################################
        
        # Yields the block with each sub brick in turn
        def each(&block)
          sub_bricks.values.each(&block)
        end
        
        ############################################################################
        ### Schema::Brick
        ############################################################################
        
        # @see DbAgile::Core::Schema::Brick#brick_composite?
        def brick_composite?
          true
        end
        
        # @see DbAgile::Core::Schema::Brick#brick_empty?
        def brick_empty?
          sub_bricks.empty?
        end
        
        # @see DbAgile::Core::Schema::Brick#brick_children
        def brick_children
          sub_bricks.values
        end
        
        # @see DbAgile::Core::Schema::Brick#[]
        def [](name)
          sub_bricks[name]
        end
        
        # @see DbAgile::Core::Schema::Brick#[]=
        def []=(name, brick)
          sub_bricks[name] = brick
          brick.send(:parent=, self)
          brick
        end
        
        ############################################################################
        ### Schema computations
        ############################################################################
        
        # Delegate pattern on minus
        def minus(other, builder)
          raise ArgumentError, "#{self.class} expected, #{other.class} received"\
            unless self.class == other.class
          builder.send(brick_builder_handler){|builder_object|
            sub_bricks.keys.each{|name|
              my_sub, other_sub = self[name], other[name]
              if other_sub.nil?
                # missing in right
                builder_object[name] = my_sub
              elsif other_sub.brick_composite?
                # present in right, possibly the same
                builder_object[name] = my_sub.minus(other_sub, builder)
              elsif my_sub != other_sub
                # present in right, conflicting
                builder_object[name] = my_sub
              else
                # present in right, same
              end
            }
          }
        end
        
        ############################################################################
        ### About IO
        ############################################################################
        
        # Delegation pattern on YAML flushing
        def to_yaml(opts = {})
          YAML::quick_emit(self, opts){|out|
            out.map("tag:yaml.org,2002:map") do |map|
              sub_bricks.keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.each{|k|
                map.add(k.to_s, sub_bricks[k])
              }
            end
          }
        end
        
        ############################################################################
        ### Equality and hash code
        ############################################################################
        
        # Compares with another brick
        def ==(other)
          return nil unless other.kind_of?(self.class)
          (self.sub_bricks == other.sub_bricks)
        end
        
        # Returns a hash code
        def hash
          sub_bricks.hash
        end
        
        # Duplicates this named collection
        def dup
          dup = self.call.new
          sub_bricks.each_pair{|name, brick|
            dup[name] = brick.dup
          }
          dup
        end
          
        ############################################################################
        ### Pseudo private methods
        ############################################################################
        
        # Handler to initialize this module
        def __initialize_named_collection
          @sub_bricks = {}
        end
        
      end # class NamedCollection
    end # class Schema
  end # module Core
end # module DbAgile