module DbAgile
  class Command
    module SQL
      #
      # Send SQL commands directly to the DBMS
      #
      # Usage: dba #{command_name} [--file=SCRIPT] [QUERY]
      #
      class Send < Command
        Command::build_me(self, __FILE__)
      
        # Query to send
        attr_accessor :query
      
        # The file to execute
        attr_accessor :file
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--file=SCRIPT", '-f',
                 "Executes a whole SQL script file") do |value|
            self.file = valid_read_file!(value)
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 0
            when 1
              self.query = valid_argument_list!(arguments, String)
            else
              bad_argument_list!(arguments)
          end
          ambigous_argument_list! if self.query and self.file
        end
      
        # Executes the command.
        def execute_command
          result = nil
          with_current_connection do |connection|
            connection.transaction do |t|
              if self.file
                result = t.direct_sql(File.read(self.file))
              elsif self.query
                result = t.direct_sql(self.query)
              else
                script = environment.input_buffer.readlines.join("\n")
                result = t.direct_sql(script)
              end
            end
          end
          case result
            when DbAgile::Contract::Data::Dataset
              result.to_text(environment.output_buffer)
            else
              flush(result)
          end
          result
        end
      
      end # class Send
    end # module SQL
  end # class Command
end # module DbAgile