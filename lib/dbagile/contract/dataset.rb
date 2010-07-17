module DbAgile
  module Contract
    module Dataset
      
      # Makes an allbut selection
      def allbut(*cs)
        arr = self.columns - cs.flatten
        select(*arr)
      end
      
      #
      # Outputs this dataset as a CSV string.
      #
      # @return [...] the buffer itself
      #
      def to_csv(buffer = "", options = {})
        DbAgile::IO::CSV::to_csv(self, self.columns, buffer, options)
      end
      
      # 
      # Outputs this dataset as a JSON string
      #
      # @return [...] the buffer itself
      #
      def to_json(buffer = "", options = {})
        DbAgile::IO::JSON::to_json(self.to_a, buffer, options)
      end
      
      # 
      # Outputs this dataset as a YAML string
      #
      # @return [...] the buffer itself
      #
      def to_yaml(buffer = "", options = {})
        DbAgile::IO::YAML::to_yaml(self.to_a, buffer, options)
      end
      
      # 
      # Outputs this dataset as a XML string
      #
      # @return [...] the buffer itself
      #
      def to_xml(buffer = "", options = {})
        DbAgile::IO::XML::to_xml(self, buffer, options)
      end
      
      # 
      # Outputs this dataset as a Ruby Array of hashes string
      #
      # @return [...] the buffer itself
      #
      def to_ruby(buffer = "", options = {})
        DbAgile::IO::Ruby::to_ruby(self, buffer, options)
      end
      
      # 
      # Outputs this dataset as plain text
      #
      # @return [...] the buffer itself
      #
      def to_text(buffer = "", options = {})
        DbAgile::IO::Text::to_text(self, self.columns, buffer, options)
      end
      
    end # module Dataset
  end # module Contract
end # module DbAgile