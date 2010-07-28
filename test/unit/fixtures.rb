require File.expand_path('../../spec_helper', __FILE__)
module DbAgile
  module Fixtures
    
    module Utils
      
      # Finds a file
      def find_file(name_or_file, resolver, extension = nil)
        if name_or_file.kind_of?(Symbol)
          name_or_file = find_file("#{name_or_file}#{extension}", resolver) 
        end
        unless name_or_file[0, 1] == '/'
          name_or_file = File.expand_path("../fixtures/#{name_or_file}#{extension}", resolver) 
        end
        name_or_file
      end
      
      # Yields block for each file with a given extension
      def each_file(resolver, extension, &block)
        Dir[File.expand_path("../fixtures/*.#{extension}", resolver)].each(&block)
      end
      
    end
    
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