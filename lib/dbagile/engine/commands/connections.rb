module DbAgile
  class Engine
    module Connections
      
      # Ping the current adapter
      def ping
        if engine.connected?
          connection.ping
        else
          false
        end
      end
      
      # Connects to database through its URI
      def connect(uri)
        engine.connect(uri)
      end
  
      # Disconnects from the engine
      def disconnect
        engine.disconnect if engine.connected?
      end
      
    end # module Connections
  end # class Engine
end # module DbAgile
      
