module DbAgile
  class Plugin
    # 
    # Shortcut for (plug Touch, :at => :insert, :force => false)
    #
    class Defaults < Touch
      
      # Overrides the default options
      def default_options
        {:at => :insert, :force => false}
      end
      
    end # class Defaults
  end # class Plugin
end # module DbAgile
      
