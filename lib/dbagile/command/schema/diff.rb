module DbAgile
  class Command
    module Schema
      #
      # Show differences between announced and effective database schemas
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
          with_current_database{|config|
            # left schema
            left = config.effective_schema(true)
            right = config.announced_schema(true)
            merged = DbAgile::Core::Schema::merge(left, right)
            show_diff(left, right, merged, environment, output_options)
          }
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
