module DbAgile
  module Tools
    class OrderedHash
      
      # Decorates a hash as an ordered hash
      def initialize(hash = {})
        @hash = hash
        @keys = hash.keys
      end
      
      # Delegated to hash
      def method_missing(name, *args, &block)
        @hash.send(name, *args, &block)
        @keys = (@keys & @hash.keys)
      end
      
      # Sets a (name,value) pair
      def []=(name, value)
        @hash[name] = value
        unless @keys.include?(name)
          @keys << name
        end
        value
      end
      
      # Puts as YAML, maintaining order
      def to_yaml(opts = {})
        YAML::quick_emit(self, opts){|out|
          out.map("tag:yaml.org,2002:map") do |map|
            @keys.each{|key|
              map.add(key.to_s, @hash[key])
            }
          end
        }
      end
      
    end # class OrderedHash
  end # module Tools
end # module DbAgile