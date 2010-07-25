module DbAgile
  module Core
    module Schema
      module Computations
        module Merge
          
          ANNOTATION_TO_COLOR = {
            :create  => HighLine::GREEN + HighLine::BOLD,
            :drop    => HighLine::RED + HighLine::BOLD,
            :alter   => :cyan,
            :same    => :black,
          }
          
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
            
            mine = :same
            builder.send(left.builder_handler, *left.builder_args){|builder_object|
              left_only.each {|key| 
                mine = :alter
                builder_object.[]=(key, left[key].dup, :drop)
              }
              right_only.each{|key| 
                mine = :alter
                builder_object.[]=(key, right[key].dup, :create)
              }
              commons.each{|key|
                on_left, on_right = left[key], right[key]
                if on_left.composite?
                  recursed = merge(on_left, on_right, builder, &block).annotation
                  if mine == :alter or recursed != :same
                    mine = :alter
                  end
                elsif on_left.look_same_as?(on_right)
                  builder_object.[]=(key, left[key].dup, :same)
                elsif block
                  resolved = block.call(on_left, on_right)
                  if resolved
                    builder_object.[]=(key, resolved, :alter)
                  end
                end
              }
              builder_object.annotation = mine
            }
          end
          
        end # module Merge
        extend(Merge)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile