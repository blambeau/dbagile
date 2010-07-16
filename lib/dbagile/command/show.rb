module DbAgile
  class Command
    #
    # Shows the content of a table
    #
    class Show < Command
      
      # Returns the command banner
      def banner
        "usage: dba show [OPTIONS] DATASET"
      end

      # Short help
      def short_help
        "Display content of a table/view/query (shortcut for 'export --text ...')"
      end
      
      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--[no-]pretty",
               "Make/Avoid pretty output (truncate string at terminal size and so on.)") do |value|
          self.pretty = value
        end
      end
      
      # Infers pretty options though highline
      def infer_terminal_cols
        begin
          gem 'highline', '>= 1.5.2'
          require 'highline'
          HighLine.new.output_cols-3
        rescue LoadError
          info("Console output is pretty with highline. Try 'gem install highline'")
          80
        end
      end
      
      # Infer options
      def infer_options(argv)
        argv = ["--text"] + argv
        if argv.include?("--no-pretty")
          argv.delete("--no-pretty")
        else
          argv += ["--truncate-at", infer_terminal_cols.to_s]
        end
        argv
      end
      
      # Override to avoid pending options to be rejected
      def unsecure_run(requester_file, argv)
        @requester_file = requester_file
        ::DbAgile::Command::API::export(infer_options(argv), environment)
      end
      
    end # class List
  end # class Command
end # module DbAgile