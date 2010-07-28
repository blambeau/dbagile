require 'yaml'
require File.expand_path('../../fixtures', __FILE__)
module DbAgile
  module Fixtures
    class YAMLDumpable
      
      attr_reader :name
      
      def initialize(name)
        @name = name
      end
      
      def to_yaml(opts = {})
        YAML::quick_emit(self, opts) do |out|
          out.map("tag:yaml.org,2002:map", :inline ) do |map|
            map.add('class', self.class.to_s)
            map.add('name', self.name)
          end
        end
        { 'test' => true }.to_yaml(opts)
      end
      
    end # class YAMLDumpable
  end # module Fixtures
end # module DbAgile