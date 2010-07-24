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
          opt.on("--[no-]skip-unchanged", 
                 "Don't show objects that did'nt change") do |value|
            self.output_options[:skip_unchanged] = value
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Shows the minus
        def show_diff(left, right)
          # format debug
          ld, rd = left.schema_identifier, right.schema_identifier
          ld, rd = ld.inspect, rd.inspect
          size = 20 + DbAgile::MathTools::max(ld.length, rd.length)
          
          # Say what will be done
          say "#"*size
          say "### LEFT: #{ld}"
          say "### RIGHT: #{rd}"
          say "### Objects to add on LEFT", :green
          say "### Objects to remove on LEFT", :red
          say "#"*size
          say "\n"
          
          to_remove = (left - right)
          to_add    = (right - left)
          say(to_add.to_yaml, :green)  
          say(to_remove.to_yaml, :red)  
        end
      
        # Executes the command
        def execute_command
          with_current_config{|config|
            left = config.effective_schema(true)
            right = config.announced_schema(true)
            merged = DbAgile::Core::Schema::Computations::merge(left, right)
            
            # format debug
            ld, rd = left.schema_identifier, right.schema_identifier
            ld, rd = ld.inspect, rd.inspect
            size = 50 + DbAgile::MathTools::max(ld.length, rd.length)

            # Say what will be done
            say "#"*size
            say "### LEFT: #{ld}"
            say "### RIGHT: #{rd}"
            say "### Objects to add on LEFT", :green
            say "### Objects to remove on LEFT", :red
            say "### Objects to alter on LEFT", :cyan
            say "#"*size
            say "\n"
            merged.yaml_say(environment, output_options)
          }
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
