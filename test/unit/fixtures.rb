require File.expand_path('../../spec_helper', __FILE__)
module DbAgile
  module Fixtures
    
    class SayHello
      def del_to_block
        yield
      end
      def say_hello(who)
        who
      end
    end
    
    class Reverse
      def say_hello(who)
        delegate.say_hello(who.reverse)
      end
    end
    
    class Upcase
      def say_hello(who)
        delegate.say_hello(who.upcase)
      end
    end
    
    class Downcase
      def say_hello(who)
        delegate.say_hello(who.downcase)
      end
    end
    
    class Capitalize
      def initialize(method = :capitalize)
        @method = method
      end
      def say_hello(who)
        delegate.say_hello(who.send(@method))
      end
    end

  end
end