module DbAgile
  module Core
    class Configuration
      
      # Creates a configuration instance
      def initialize(&block)
        @uri = nil
        @connector = ::DbAgile::Core::Connector.new
        self.instance_eval(&block) if block
      end
      
      # Sets the configuration URI
      def uri(uri = nil)
        @uri = uri unless uri.nil?
        @uri
      end
      
      # @see Connector#plug
      def plug(*args)
        @connector.plug(*args)
      end
      
      # Connects and returns a Connection object
      def connect(uri = @uri, options = {})
        adapter = DbAgile::Adapter::factor(uri || @uri, options)
        connector = @connector.connect(adapter)
        Connection.new(connector)
      end
      
    end # class Configuration
  end # module Core
end # module DbAgile 