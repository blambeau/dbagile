module FlexiDB
  class Engine
    class Signature
      
      # Signature arguments
      attr_reader :arguments
      
      # Creates a signature instance
      def initialize(&block)
        @arguments = []
        self.instance_eval(&block) if block
      end
      
      # Adds an argument to the signature
      def add_argument(name, *checks, &block)
        checks << block if block
        arguments << [name, checks]
      end
      
      # Returns banner of this signature
      def banner(name)
        if arguments.empty? 
          name
        else
          "#{name} #{arguments.collect{|args| args[0]}.join(' ')}"
        end
      end
      
      # Does the signature matches some arguments?
      def match(args)
        return nil unless args.size == arguments.size
        result = {}
        arguments.each_with_index do |argument, i| 
          name, checks = argument
          value = args[i]
          return nil unless checks.all?{|check|
            case check
              when Proc
                begin
                  check.call(value)
                rescue => ex
                  return nil
                end
              else
                check === value
            end
          }
          result[name] = value
        end
        result
      end

    end # class Signature
  end # class Engine
end # module FlexiDB