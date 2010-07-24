module DbAgile
  module Core
    class Schema
      module Computations
        module Minus
          
          # Computes set difference between schemas.
          def minus(left, right, builder)
            unless left.class == right.class
              raise ArgumentError, "#{left.class} != #{right.class}"
            end
            
            args = left.respond_to?(:name) ? [ left.name ] : [ ]
            builder.send(left.brick_builder_handler, *args){|builder_object|
              left.brick_subbrick_keys.each{|name|
                left_sub, right_sub = left[name], right[name]
                if right_sub.nil?
                  # missing in right
                  builder_object[name] = left_sub
                elsif left_sub.brick_composite?
                  # present in right, possibly the same
                  builder_object[name] = minus(left_sub, right_sub, builder)
                elsif left_sub != right_sub
                  # present in right, conflicting
                  builder_object[name] = left_sub
                else
                  # present in right, same
                end
              }
            }
            
          end
          
        end # module Minus
        extend(Minus)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile