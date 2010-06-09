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
          begin
            case res = h.ask("flexidb=# ")
              when '\q', 'quit'
                break
              when /^[a-zA-Z0-9_]+$/
                show_dataset(database.dataset(res.to_sym))
              when /^\s*(select|SELECT)/
                show_dataset(database.direct_sql(res))
              when /^\s*(insert\s+into|INSERT\s+INTO)/
                puts database.direct_sql(res)
              when /^\s*(delete|DELETE)/
                puts database.direct_sql(res)
              else
                puts database.instance_eval(res).inspect
            end
          rescue => ex
            h.say("Error occured: #{ex.message}")
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