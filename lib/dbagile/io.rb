require 'dbagile/io/type_safe'
require 'dbagile/io/pretty_table'
require 'dbagile/io/csv'
require 'dbagile/io/json'
require 'dbagile/io/yaml'
require 'dbagile/io/xml'
require 'dbagile/io/html'
require 'dbagile/io/ruby'
require 'dbagile/io/text'
module DbAgile
  module IO
    
    # Options to set to ensure roundtrip on each format
    ROUND_TRIP_OPTIONS = {
      :type_system => SByC::TypeSystem::Ruby
    }
      
    # Known IO formats
    KNOWN_FORMATS = [:yaml, :csv, :json, :ruby, :text, :xml, :html]
    
    # Known to_xxx IO formats
    KNOWN_TO_FORMATS = [:yaml, :csv, :json, :ruby, :text, :xml, :html]
    
    # Known from_xxx formats
    KNOWN_FROM_FORMATS = [:yaml, :csv, :json, :ruby]
    
    # Format to helper module
    FORMAT_TO_MODULE = {
      :yaml => DbAgile::IO::YAML,
      :csv  => DbAgile::IO::CSV,
      :json => DbAgile::IO::JSON,
      :ruby => DbAgile::IO::Ruby,
      :text => DbAgile::IO::Text,
      :xml  => DbAgile::IO::XML,
      :html => DbAgile::IO::HTML
    }
    
    # Which format for what extension
    EXTENSION_TO_FORMAT = {
      ".csv"   => :csv,
      ".txt"   => :text,
      ".json"  => :json,
      ".yaml"  => :yaml,
      ".yml"   => :yaml,
      ".xml"   => :xml,
      ".html"  => :html,
      ".ruby"  => :ruby,
      ".rb"    => :ruby
    }
    
    # Which content type for which format
    FORMAT_TO_CONTENT_TYPE = {
      :csv  => "text/csv",
      :text => "text/plain",
      :json => "application/json",
      :yaml => "text/yaml",
      :xml  => "text/xml",
      :html => "text/html",
      :ruby => "text/plain"
    }
      
    # Checks if an extension is known. Returns the associated format.
    def known_extension?(f)
      f = ".#{f}" unless f[0,1] == '.'
      EXTENSION_TO_FORMAT[f]
    end
    
    # Checks if a format is known. Returns the associated content type.
    def known_format?(f)
      FORMAT_TO_CONTENT_TYPE[f]
    end
    
    # Returns roundtrip options
    def roundtrip_options(format)
      ROUND_TRIP_OPTIONS
    end
    
    # Install helper methods now
    KNOWN_TO_FORMATS.each{|format|
      module_eval <<-EOF
        def to_#{format}(*args, &block)
          FORMAT_TO_MODULE[#{format.inspect}].to_#{format}(*args, &block)
        end
      EOF
    }
    
    # Install helper methods now
    KNOWN_FROM_FORMATS.each{|format|
      module_eval <<-EOF
        def from_#{format}(*args, &block)
          FORMAT_TO_MODULE[#{format.inspect}].from_#{format}(*args, &block)
        end
      EOF
    }
    
    extend(DbAgile::IO)
  end # module IO
end # module DbAgile