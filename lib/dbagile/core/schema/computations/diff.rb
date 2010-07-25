module DbAgile
  module Core
    module Schema
      module Computations
        module Diff
          
          # Computes set difference between schemas.
          def diff(left, right, &block)
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
            
            left_only.each {|key| 
              block.call(:missing_on_right, left[key], nil)
            }
            right_only.each{|key| 
              block.call(:missing_on_left, nil, right[key])
            }
            commons.each{|key|
              on_left, on_right = left[key], right[key]
              if on_left.composite?
                diff(on_left, on_right, &block)
              elsif on_left.look_same_as?(on_right)
                block.call(:same, on_left, on_right)
              else
                block.call(:conflicting, on_left, on_right)
              end
            }
          end
          
        end # module Minus
        extend(Diff)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile