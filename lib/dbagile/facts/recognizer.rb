module DbAgile
  class Facts
    class Recognizer
      
      # Extracts the key of a fact tuple
      def fact_key(name, fact)
        fact.dup.delete_if{|k, v| !(/[#]$/ =~ k.to_s)}
      end
      
      #
      # Normalize a fact argument
      #
      # @return [Symbol, Hash] a normalized pair with fact name as a Symbol and
      #         fact attributes as a Hash
      #
      # Following conversions are implemented:
      #   normalize_fact(:supplier, { :'supplier#' => 1, ... }) -> unchanged
      #   normalize_fact(:supplier, { :'#' => 1, ... }) -> [:supplier, {:'supplier#' => 1, ...}]
      #   normalize_fact({ :'supplier#' => 1, ... }) -> [:supplier, {:'supplier#' => 1, ...}]
      #   normalize_fact(:supplier, { :'s#' => 1, 'p#' => 2 }) -> unchanged
      #
      def normalize_fact(*args)
        if args.size == 1 
          if args[0].kind_of?(Hash)
            return normalize_hash_fact(args[0])
          end
        elsif args.size == 2
          if args[0].kind_of?(Symbol) and args[1].kind_of?(Hash)
            name = args[0]
            hash = args[1].dup
            if hash.key?(:'#')
              hash[:"#{name}#"] = hash[:'#'] 
              hash.delete(:'#')
            end
            return [name, hash]
          end
        end
        raise InvalidFactFormatError, "Invalid fact: #{args.inspect}"
      end
      
      # Internal implementation of normalize_fact where a hash is given
      def normalize_hash_fact(fact)
        keys = fact.keys.select{|k| /[#]$/ =~ k.to_s}
        if keys.size != 1 or keys[0] == :'#'
          raise InvalidFactFormatError, "Invalid fact: #{fact.inspect}"
        else
          name = keys[0].to_s.match(/(.*)[#]$/)[1].to_sym
          [name, fact]
        end
      end
      
    end # class Recognizer
  end # class Facts
end # module DbAgile