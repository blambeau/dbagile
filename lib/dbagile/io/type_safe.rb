module DbAgile
  module IO
    module TypeSafe
      
      # Encodes a tuple to a type safe tuple
      def to_typesafe_tuple(type_system, tuple)
        return tuple if type_system.nil?
        copy = {}
        tuple.each_pair{|k,v| copy[k] = type_system.to_literal(v)}
        copy
      end
      
      # Yields the block with each tuple in turn
      def with_type_safe_relation(data, options, &block)
        if ts = options[:type_system]
          data.each{|t| block.call(to_typesafe_tuple(ts, t))}
        else
          data.each(&block)
        end
      end
      
      # Encodes a tuple to a type safe tuple
      def to_typesafe_relation(type_system, relation)
        return relation if type_system.nil?
        relation.collect{|t| to_typesafe_tuple(type_system, t)}
      end
      
      # Decodes a type-safe tuple to a tuple
      def from_typesafe_tuple(type_system, tuple)
        return tuple if type_system.nil?
        copy = {}
        tuple.each_pair{|k,v| copy[k] = type_system.parse_literal(v)}
        copy
      end
      
      # Decodes an type-safe encoded relation
      def from_typesafe_relation(type_system, relation)
        return relation if type_system.nil?
        relation.collect{|t| from_typesafe_tuple(type_system, t)}
      end
      
      # Implements the from_xxx emitter spec
      def from_typesafe_xxx(data, options, &block)
        if block.nil?
          from_typesafe_relation(options[:type_system], data)
        else
          if data.respond_to?(:each)
            ts = options[:type_system]
            data.each do |d|
              raise DbAgile::InvalidFormatError, "Loaded tuple should be an hash (#{d.inspect})" unless d.kind_of?(Hash)
              yield(from_typesafe_tuple(ts, d))
            end
          else 
            raise DbAgile::InvalidFormatError, "Loaded data should be an array of tuples (#{data.inspect})"
          end
          nil
        end
      end
      
    end # module TypeSafe
  end # module IO
end # module DbAgile