module DbAgile
  class Command
    module Schema
      #
      # Show differences between announed and effective database schemas
      #
      # Usage: dba #{command_name}
      #
      class Diff < Command
        include Schema::ComparisonBased
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
          opt.on("--[no-]skip-unchanged", "-u",
                 "Don't show objects that did'nt change") do |value|
            self.output_options[:skip_unchanged] = value
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Executes the command
        def execute_command
          with_current_config{|config|
            # left schema
            left = config.effective_schema(true)
            right = config.announced_schema(true)
            merged = DbAgile::Core::Schema::merge(left, right)
            
            # Validity
            if left.looks_valid?
              lv = environment.color("(valid!)", :green)
            else
              lv = environment.color("(WARNING, you'd better run 'dba schema:check --effective')", :magenta)
            end
            if right.looks_valid?
              rv = environment.color("(valid!)", :green)
            else
              rv = environment.color("(WARNING, you'd better run 'dba schema:check')", :magenta)
            end
            
            # Debug
            ld, rd = left.schema_identifier.inspect, right.schema_identifier.inspect
            ld, rd = "#{ld} #{lv}", "#{rd} #{rv}"
            
            # Say
            say '###'
            say "### LEFT: #{ld}"
            say "### RIGHT: #{rd}"
            say '###'
            say "### " + environment.color('Objects to add on LEFT', :green)
            say '### ' + environment.color('Objects to remove on LEFT', :red)
            say '### ' + environment.color('Objects to alter on LEFT', :cyan)
            say '###'
            say "\n"
            merged.yaml_say(environment, output_options)

          }
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
