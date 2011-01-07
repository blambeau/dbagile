module DbAgile
  module Core
    # 
    # Provides a ruby handler on a SQL database backend (aka server)
    #
    class Backend
      
      # Backend's name
      attr_reader :name
      
      # Backend's configuration hash
      attr_reader :config
      
      # Command wrappers
      attr_reader :wrappers
      
      # List of available commands
      attr_reader :commands
      
      # Creates a backend instance
      def initialize(name)
        @name = name
        @config = Map.new
        @wrappers = Map.new
        @commands = Map.new
      end
      
      # Sets the configuration hash
      def config=(config)
        @config = Map.new(config)
      end
      
      # Sets the wrappers hash
      def wrappers=(wrappers)
        @wrappers = Map.new(wrappers)
      end
      
      # Sets the commands hash
      def commands=(commands)
        @commands = Map.new(commands)
      end
      
      # Instantiates a command whose name is provided
      def instantiate_command(name)
        if cmd_text = commands[name]
          cmd_text = "<<EOF\n#{cmd_text}\nEOF"
          cmd_text = config.instance_eval(cmd_text)
          if w = wrappers[:default]
            wrapped = "<<EOF\n#{w}\nEOF"
            wrapped = config.merge(:command => cmd_text).instance_eval(wrapped)
          end
        else
          raise DbAgile::NoSuchCommandError, "Unknown backend command #{name}"
        end
      end
      
      # Converts this database to a yaml string
      def to_yaml(opts = {})
        YAML::quick_emit(self, opts){|out|
          out.map("tag:yaml.org,2002:map") do |map|
            map.add('config', config) if config
            map.add('wrappers', wrappers) if wrappers
            map.add('commands', commands) if commands
          end
        }
      end
      
    end # class Backend
  end # module Core
end # module DbAgile