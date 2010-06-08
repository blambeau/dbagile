module FlexiDB
  module Commands
    class Main < Command
      
      # Contribute to options
      def add_options(opt)
      end
      
      # Returns the command banner
      def banner
        "flexidb [options] URI"
      end
      
      # Runs the sub-class defined command
      def __run(requester_file, arguments)
        # Checks that an URI is accessible or stop here
        self.uri = arguments[0] unless self.uri
        exit("Missing database URI", true) unless self.uri
        
        # Start the query engine on that uri
        database = connect_database
        
        # Main highline loop
        h = HighLine.new
        while true
          case res = h.ask("flexidb=# ")
            when '\q', 'quit'
              break
            when /^[a-zA-Z0-9_]+$/
              if database.table_exists?(res.to_sym)
                show_dataset(database[res.to_sym])
              else
                h.say("No such table #{res}")
              end
            when /^\s*SELECT/
              show_dataset(database.direct_sql(res))
          end
        end
      end
      
      # Shows the content of a table
      def show_dataset(dataset)
        dataset.each do |row|
          puts row.inspect
        end
      end
      
    end # class Main
  end # module Commands
end # module FlexiDB