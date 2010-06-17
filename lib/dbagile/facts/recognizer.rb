module DbAgile
  class Facts
    class Recognizer
      
      DEFAULT_OPTIONS = {
        :key_recognizer => /[#]$/,
        :key_names => {}
      }

      # Options
      attr_reader :options

      # Creates a Recognizer instance
      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
      end
      
      # Returns default options
      def default_options
        DEFAULT_OPTIONS
      end
      
      # Returns true if k is part of key, false otherwise
      def is_key_part?(k)
        options[:key_recognizer] =~ k.to_s
      end
      
      # Extracts the key attributes of a tuple
      def extract_key(tuple)
        tuple.keys.select{|k| is_key_part?(k)}.sort{|k1, k2| k1.to_s <=> k2.to_s}
      end
      
      # Returns the name of a fact
      def fact_name(fact)
        key = extract_key(fact)
        options[:key_names][key] || key.collect{|k| k.to_s}.join.to_sym
      end
      
    end # class Recognizer
  end # class Facts
end # module DbAgile