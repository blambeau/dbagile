module DbAgile
  class Command
    #
    # Send sequel directly to the DBMS
    #
    class SQL < Command
      
      # Query to send
      attr_accessor :query
      
      # The file to execute
      attr_accessor :file
      
      # Returns command's category
      def category
        :sql
      end
      
      # Returns the command banner
      def banner
        "Usage: dba sql QUERY"
      end

      # Short help
      def short_help
        "Send SQL directly to the DBMS"
      end
      
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
        if arguments.empty?
          bad_argument_list!(arguments) unless self.file
        else
          self.query = valid_argument_list!(arguments, String)
        end
      end
      
      #
      # Executes the command.
      #
      # @return [DbAgile::Core::Configuration] the created configuration
      #
      def execute_command
        result = nil
        with_current_config do |config|
          config.connect.transaction do |t|
            result = t.direct_sql(File.read(self.file)) if self.file
            result = t.direct_sql(self.query) if self.query
          end
        end
        case result
          when DbAgile::Contract::Dataset
            result.to_text(environment.output_buffer)
          else
            display(result)
        end
        result
      end
      
    end # class SQL
  end # class Command
end # module DbAgile