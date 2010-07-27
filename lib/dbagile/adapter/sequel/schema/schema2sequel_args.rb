module DbAgile
  class SequelAdapter < Adapter
    module Schema
      module Schema2SequelArgs
      
        #
        # Returns Sequel's column argument from an Attribute instance
        #
        def attribute2column_args(attribute)
          options = {:null => !attribute.mandatory?}
          unless (defa = attribute.default_value).nil?
            options[:default] = defa
          end
          [attribute.name, attribute.domain, options]
        end
      
        #
        # Returns Sequel's primary_key arguments from a CandidateKey 
        # instance
        #
        def candidate_key2primary_key_args(ckey)
          columns = ckey.key_attributes.collect{|c| c.name} 
          options = {}
          [ columns, options ]
        end
      
        #
        # Returns Sequel's unique arguments from a CandidateKey 
        # instance
        #
        def candidate_key2unique_args(ckey)
          columns = ckey.key_attributes.collect{|c| c.name} 
          options = {}
          [ columns, options ]
        end
      
        # 
        # Returns Sequel's foreign_key arguments from a ForeignKey 
        # instance.
        #
        def foreign_key2foreign_key_args(fkey)
          target_relvar = fkey.target_relvar.name
          source_names = fkey.source_attributes.collect{|a| a.name}
          target_names  = fkey.target_key.key_attributes.collect{|a| a.name}
          [source_names, target_relvar, { :key => target_names }]
        end
      
        #
        # Returns Sequel's index arguments from an Index instance.
        # 
        def index2index_args(index)
          attr_names = index.indexed_attributes.collect{|a| a.name}
          [ attr_names ]
        end
      
      end # module Schema2SequelArgs
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
    
