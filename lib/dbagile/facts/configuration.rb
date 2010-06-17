module DbAgile
  class Facts
    module Configuration
      
      # Fact recognizer
      attr_accessor :recognizer
      
      # Installs the default configuration
      def default_configuration!
        @recognizer = Recognizer.new
      end
      
    end # module Configuration
  end # class Facts
end # module DbAgile