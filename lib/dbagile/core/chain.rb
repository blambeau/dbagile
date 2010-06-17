require 'delegate'
require 'enumerator'
module DbAgile
  module Core
    class Chain
      
      # A participant in the chain
      module Participant
        def __getobj__() @__delegate__ end
        alias :delegate :__getobj__
      end
      
      # Returns the delegator chain
      attr_reader :delegate_chain
      
      # Creates a chain instance. Shortcut for Chain.new(*args)
      def self.[](*args)
        Chain.new(*args)
      end
      
      # Creates an empty chain
      def initialize(*chain)
        @delegate_chain = []
        plug(*chain) unless chain.empty?
        __install_chain__
      end
      
      # Handles the magic of delegation through \_\_getobj\_\_.
      def method_missing(m, *args, &block)
        target = self.__getobj__
        unless target.respond_to?(m)
          super
        end
        target.__send__(m, *args, &block)
      end

      # Builds some participants
      def __build_participants__(args)
        delegates = []
        until args.empty?
          case arg = args.shift
            when Class
              mod_args = []
              until args.empty? or args[0].kind_of?(Module)
                mod_args << args.shift
              end
              delegates << arg.new(*mod_args)
            else
              delegates << arg
          end
        end
        delegates
      end
      
      # Installs the chain
      def __install_chain__
        delegate_chain.each_cons(2) do |part, its_del|
          part.extend(Participant)
          part.instance_eval{ @__delegate__ = its_del }
        end
      end
      
      # Returns the delegation object
      def __getobj__
        delegate_chain.first
      end
      
      # Plugs some chain participants
      def plug(*args)
        @delegate_chain = __build_participants__(args) + delegate_chain
        __install_chain__
        self
      end
      
      # Returns a connected version of self.
      def connect(last)
        chain = delegate_chain + [ last ]
        Chain.new(*chain)
      end
      
      # Inspects this chain
      def inspect
        debug = delegate_chain.collect{|c| 
          c.kind_of?(Chain) ? c.inspect : c.class.name
        }.join(', ')
        "[#{debug}]"
      end
      
      protected :__getobj__
    end # class Chain
  end # module Core
end # module DbAgile