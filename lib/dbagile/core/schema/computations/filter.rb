module DbAgile
  module Core
    module Schema
      module Computations
        module Filter
          
          # Default filtering options
          DEFAULT_OPTIONS = {}
          
          # Computes set difference between schemas.
          def filter(object, options, builder, &block)
            unless object.composite?
              raise ArgumentError, "Filter called on a part object!"
            end
            
            # Make a deep filtered copy 
            keys = object.part_keys
            copied = builder.send(object.builder_handler, *object.builder_args){|builder_object|
              keys.each{|key|
                sub_object = object[key]
                if sub_object.composite?
                  filter(sub_object, options, builder, &block)
                else
                  if block.call(sub_object)
                    builder_object.[]=(key, sub_object.dup)
                  end
                end
              }
              builder_object
            }
            
            copied
          end
          
        end # module Filter
        extend(Filter)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile