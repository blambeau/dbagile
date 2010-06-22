module Facts
  module Restful
    class Server
      module Get
        
        # Implements GET access of the restful interface
        def get(env)
          env_to_fact_access do |name, proj|
            if proj.nil?
              db.facts(name)
          end
        end
        
      end # module Get
    end # class Server
  end # module Restful
end # module Facts