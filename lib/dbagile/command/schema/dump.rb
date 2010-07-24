module DbAgile
  class Command
    module Schema
      #
      # Dump database schema (announced by default) 
      #
      # Usage: dba #{command_name} [--effective|--physical]
      #
      class Dump < Command
        Command::build_me(self, __FILE__)
        
        # Dump reference
        attr_accessor :reference
      
        # Returns command's category
        def category
          :schema
        end

        # Sets the default options
        def set_default_options
          self.reference = :announced
        end
    
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on('--effective', "Dump (what plays the role of) effective schema") do |value|
            self.reference = :effective
          end
          opt.on('--physical', "Dump the physical schema (limited feature!)") do |value|
            self.reference = :physical
          end
        end
      
        # Executes the command
        def execute_command
          schema = nil
          with_current_config do |config|
            schema = case reference
              when :effective
                config.effective_schema(true)
              when :physical
                config.physical_schema
              else
                config.announced_schema(true)
            end
            say("# Schema of #{schema.schema_identifier}", :magenta)
            display schema.to_yaml
          end
          schema
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
