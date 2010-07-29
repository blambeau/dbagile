module DbAgile
  class Command
    module Schema
      #
      # Show differences between announced and effective database schemas
      #
      # Usage: dba #{command_name} [SCHEMA_ARG, ...]
      #
      class Diff < Command
        include Schema::Commons
        Command::build_me(self, __FILE__)
      
        # Output options
        attr_reader :output_options
      
        # Sets the default options
        def set_default_options
          @output_options = {:skip_unchanged => false}
        end
    
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_check_options(opt)
          opt.on("--[no-]skip-unchanged", "-u",
                 "Don't show objects that did'nt change") do |value|
            self.output_options[:skip_unchanged] = value
          end
        end
      
        # Returns :single
        def kind_of_schema_arguments
          :double
        end
      
        # Executes the command
        def execute_command
          with_schemas do |left, right|
            merged = DbAgile::Core::Schema::merge(left, right)
            show_diff(left, right, merged, environment, output_options)
            merged
          end
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
        
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
