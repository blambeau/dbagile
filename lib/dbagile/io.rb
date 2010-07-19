require 'dbagile/io/type_safe'
require 'dbagile/io/pretty_table'
require 'dbagile/io/csv'
require 'dbagile/io/json'
require 'dbagile/io/yaml'
require 'dbagile/io/xml'
require 'dbagile/io/ruby'
require 'dbagile/io/text'
module DbAgile
  module IO
    
    # Known IO formats
    KNOWN_FORMATS = [:yaml, :csv, :json, :ruby, :text, :xml]
    
    # Known to_xxx IO formats
    KNOWN_TO_FORMATS = [:yaml, :csv, :json, :ruby, :text, :xml]
    
    # Known from_xxx formats
    KNOWN_FROM_FORMATS = [:yaml, :csv, :json, :ruby]
    
    # Format to helper module
    FORMAT_TO_MODULE = {
      :yaml => DbAgile::IO::YAML,
      :csv  => DbAgile::IO::CSV,
      :json => DbAgile::IO::JSON,
      :ruby => DbAgile::IO::Ruby,
      :text => DbAgile::IO::Text,
      :xml  => DbAgile::IO::XML
    }
    
    # Which format for what extension
    EXTENSION_TO_FORMAT = {
      ".csv"   => :csv,
      ".txt"   => :text,
      ".json"  => :json,
      ".yaml"  => :yaml,
      ".yml"   => :yaml,
      ".xml"   => :xml,
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
    
    # Install helper methods now
    FORMAT_TO_MODULE.each_pair do |format, mod|
      module_eval <<-EOF
        def to_#{format}(*args, &block)
          #{mod}.to_#{format}(*args, &block)
        end
      EOF
    end
    
    extend(DbAgile::IO)
  end # module IO
end # module DbAgile