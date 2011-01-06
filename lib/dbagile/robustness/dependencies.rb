module DbAgile
  module Robustness
    module Dependencies

      # Raises when a dependency is missing
      class ::DbAgile::DependencyError < ::DbAgile::Error; end

      # Asserts that a standard library 
      def has_stdlib!(util_name, msg = nil)
        require util_name
      rescue StandardError => ex
        if msg.nil?
          msg = "DbAgile requires #{util_name} but failed to load it" 
        end
        msg = "#{msg}\n#{ex.message}"
        raise DbAgile::DependencyError, msg, ex.backtrace
      end
      
      # Asserts that a gem exists and is loaded
      def has_gem!(gem_name, gem_version = nil, msg = nil)
        require 'rubygems'
        gem gem_name, gem_version
        require gem_name
      rescue StandardError => ex
        if msg.nil?
          msg = gem_version.nil? ? gem_name : "#{gem_name} (#{gem_version})"
          msg = "DbAgile requires #{msg} but failed to load it" 
        end
        msg = "#{msg}\n#{ex.message}"
        raise DbAgile::DependencyError, msg, ex.backtrace
      end
      
    end # module Dependencies
    extend(Dependencies)
  end # module Robustness
end # module DbAgile
