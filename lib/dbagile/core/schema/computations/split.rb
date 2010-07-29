module DbAgile
  module Core
    module Schema
      module Computations
        module Split
          
          # Default split options
          DEFAULT_OPTIONS = {}
          
          # Computes set difference between schemas.
          def split(schema, options, &block)

            # Build the split hash
            split_hash = Hash.new{|h,k| h[k] = []}
            schema.visit{|object, parent|
              if object.part?
                kind = block.call(object)
                split_hash[kind] << object
              end
            }
            
            # Rebuild schemas now
            schemas = {}
            split_hash.keys.each{|kind|
              split_proc    = lambda{|obj| split_hash[kind].include?(obj)}
              split_options = {:identifier => kind}
              schemas[kind] = Schema::filter(schema, split_options, &split_proc)
            }
            schemas
          end
          
        end # module Split
        extend(Split)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile