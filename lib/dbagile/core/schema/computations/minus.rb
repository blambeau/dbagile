module DbAgile
  module Core
    module Schema
      module Computations
        module Minus
          
          # Computes set difference between schemas.
          def minus(left, right, builder)
            unless left.class == right.class
              raise ArgumentError, "#{left.class} != #{right.class}"
            end
            unless left.composite?
              raise ArgumentError, "Minus called on a part object!"
            end
            
            result = builder.send(left.builder_handler, *left.builder_args){|builder_object|
              left.part_keys.each{|name|
                left_sub, right_sub = left[name], right[name]
                if right_sub.nil?
                  # missing in right
                  builder_object[name] = left_sub.dup
                elsif left_sub.composite?
                  # present in right, possibly the same
                  minus(left_sub, right_sub, builder)
                elsif not(left_sub.look_same_as?(right_sub))
                  # present in right, conflicting
                  builder_object[name] = left_sub.dup
                else
                  # present in right, same 
                  # (following line otherwise, not counted by rcov)
                  1
                end
              }
            }
            
            result
          end
          
        end # module Minus
        extend(Minus)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile