module DbAgile
  class Command
    module SQL
      #
      # Display content of a table/view/query (shortcut for 'export --text ...')
      #
      # Usage: dba #{command_name} [OPTIONS] DATASET
      #
      class Show < Command
        Command::build_me(self, __FILE__)
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--[no-]pretty",
                 "Make/Avoid pretty output (truncate string at terminal size and so on.)") do |value|
            self.pretty = value
          end
        end
      
        # Infer options
        def infer_options(argv)
          argv = ["--text"] + argv
          if argv.include?("--no-pretty")
            argv.delete("--no-pretty")
          else
            argv += ["--truncate-at", environment.console_width.to_s]
          end
          argv
        end
      
        # Override to avoid pending options to be rejected
        def unsecure_run(requester_file, argv)
          DbAgile::dba(environment){|dba| dba.bulk_export(infer_options(argv))}
          environment.output_buffer
        end
      
      end # class Show
    end # module SQL
  end # class Command
end # module DbAgile