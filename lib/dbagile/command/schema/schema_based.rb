module DbAgile
  class Command
    module Schema
      module SchemaBased
        
        # Returns command's category
        def category
          :schema
        end

        # Schema file
        attr_accessor :schema_file
      
        # Dump reference
        attr_accessor :reference
      
        # Adds [--effective|--physical] options. Expects self.reference= accessor.
        def add_effective_pysical_options(opt)
          @reference = :announced
          opt.on('--effective', "Work on (what plays the role of) effective schema") do |value|
            self.reference = :effective
          end
          opt.on('--physical', "Work on the physical schema (limited feature!)") do |value|
            self.reference = :physical
          end
        end
        
        # Yields the block with expected schema, based on reference 
        # and other option conventions
        def with_schema
          schema = nil
          if schema_file
            file = valid_read_file!(schema_file)
            schema = DbAgile::Core::Schema::yaml_file_load(file)
            schema.schema_identifier = file
          elsif reference
            schema = with_current_database do |database|
              case reference
                when :announced
                  database.announced_schema(true)
                when :effective
                  database.effective_schema(true)
                when :physical
                  database.physical_schema
              end
            end
          else
            raise DbAgile::InternalError, "Unexpected situation on SchemaBased."
          end
          yield(schema)
        end
        
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_effective_pysical_options(opt)
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 0
            when 1
              self.schema_file = valid_read_file!(arguments.shift)
            else
              bad_argument_list!(arguments)
          end
        end
        
      end # module Options
    end # module Schema
  end # class Command
end # module DbAgile