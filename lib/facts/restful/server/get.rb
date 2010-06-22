module Facts
  module Restful
    class Server
      module Get
        
        # Implements GET access of the restful interface
        def get(env)
          kind, name, projection = decode(env)
          if db.fact?(name, projection)
            [200, {}, kind == :relation ? db.facts(name, projection) : db.fact(name, projection)]
          else
            [404, {}, ["No such fact"]]
          end
        end
        
      end # module Get
    end # class Server
  end # module Restful
end # module Facts