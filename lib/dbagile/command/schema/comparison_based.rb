module DbAgile
  class Command
    module Schema
      module ComparisonBased
        
        # Normalizes the pending arguments
        def normalize_comparison_arguments(arguments)
          bad_argument_list!(arguments) unless arguments.empty?
        end
        
        # Shows difference between left and right
        def show_diff(left, right, merged, environment, output_options)
          # Validity
          if left.looks_valid?
            lv = environment.color("(valid!)", :green)
          else
            lv = environment.color("(INVALID, you'd better run 'dba schema:check --effective')", HighLine::RED + HighLine::BOLD)
          end
          if right.looks_valid?
            rv = environment.color("(valid!)", :green)
          else
            rv = environment.color("(INVALID, you'd better run 'dba schema:check')", HighLine::RED + HighLine::BOLD)
          end
          
          # Debug
          ld, rd = left.schema_identifier.inspect, right.schema_identifier.inspect
          ld, rd = "#{ld} #{lv}", "#{rd} #{rv}"
          
          # Say
          environment.say '###'
          environment.say "### LEFT: #{ld}"
          environment.say "### RIGHT: #{rd}"
          environment.say '###'
          environment.say "### " + environment.color('Objects to add on LEFT', :green)
          environment.say '### ' + environment.color('Objects to remove on LEFT', :red)
          environment.say '### ' + environment.color('Objects to alter on LEFT', :cyan)
          environment.say '###'
          environment.say "\n"
          merged.yaml_say(environment, output_options)
          environment.say "\n"
        end
        
      end # module ComparisonBased
    end # module Schema
  end # class Command
end # module DbAgile