module DbAgile
  module Core
    module Schema
      module Computations
        module Merge
          
          # Computes set difference between schemas.
          def merge(left, right, builder, &block)
            unless left.class == right.class
              raise ArgumentError, "#{left.class} != #{right.class}"
            end
            unless left.composite?
              raise ArgumentError, "Diff called on a part object!"
            end
            
            # Computes key differences
            left_keys, right_keys = left.part_keys(true), right.part_keys(true)
            left_only  = left_keys - right_keys
            right_only = right_keys - left_keys
            commons    = left_keys & right_keys 
            
            mine = Schema::NO_CHANGE
            builder.send(left.builder_handler, *left.builder_args){|builder_object|
              left_only.each {|key| 
                mine = Schema::TO_ALTER
                builder_object.[]=(key, left[key].dup, Schema::TO_DROP)
              }
              right_only.each{|key| 
                mine = Schema::TO_ALTER
                builder_object.[]=(key, right[key].dup, Schema::TO_CREATE)
              }
              commons.each{|key|
                on_left, on_right = left[key], right[key]
                if on_left.composite?
                  recursed = merge(on_left, on_right, builder, &block).status
                  mine = Schema::TO_ALTER if recursed != Schema::NO_CHANGE
                elsif on_left.look_same_as?(on_right)
                  builder_object.[]=(key, left[key].dup, Schema::NO_CHANGE)
                elsif block
                  resolved = block.call(on_left, on_right)
                  if resolved
                    builder_object.[]=(key, resolved, Schema::TO_ALTER)
                  end
                end
              }
              builder_object.status = mine
            }
          end
          
        end # module Merge
        extend(Merge)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile