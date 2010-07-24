module DbAgile
  class Command
    module Schema
      module ComparisonBased
        
        # Returns command's category
        def category
          :schema
        end

        # Normalizes the pending arguments
        def normalize_comparison_arguments(arguments)
          bad_argument_list!(arguments) unless arguments.empty?
        end
        
        # Shows the minus
        def show_minus(left_schema, right_schema, kind)
          ld, rd = left_schema.schema_identifier, right_schema.schema_identifier
          ld, rd = ld.inspect, rd.inspect
          size = 20 + DbAgile::MathTools::max(ld.length, rd.length)
          color = (kind == :add ? :green : :red)
          say "#"*size
          say "### LEFT: #{ld}"
          say "### RIGHT: #{rd}"
          say "### Objects to #{kind} on LEFT", color
          say "#"*size
          say "\n"
          minus = (left_schema - right_schema)
          if minus.empty?
            say("nothing to do", :magenta)
            say "\n"
          else
            say(minus.to_yaml, color)  
          end
          say ""
        end
      
      end # module ComparisonBased
    end # module Schema
  end # class Command
end # module DbAgile