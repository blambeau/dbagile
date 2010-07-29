module DbAgile
  module DotOrg
    class SchemaConverter
      include DotOrg::Utils
      
      def schema2script(filepath, adapter, script_kind)
        sql = ""
        DbAgile::dba{|dba|
          dba.repository_path = ::File.expand_path('../../dbagile.yaml', __FILE__)
          dba.output_buffer = StringIO.new
          dba.repo_use [ adapter ]
          dba.output_buffer = StringIO.new
          dba.schema_sql_script [script_kind, filepath]
          sql = dba.output_buffer.string
        }
      end
      
      def wrap(str, col_width = 100)
        str.gsub!( /(\S{#{col_width}})(?=\S)/, '\1 ' )
        str.gsub!( /(.{1,#{col_width}})(?:\s+|$)/, "\\1\n" )
        str
      end
      
      def call(env)
        req = Rack::Request.new(env)
        if file_info = req.params['schema_file']
          filepath = file_info[:tempfile].path
          adapter = req.params['adapter'] || 'postgres'
          script_kind = req.params['script_kind'] || 'create'          
          script = schema2script(filepath, adapter, script_kind)
          #script = wrap(script)
          wlang_on_page(env, "convert", MAIN_TEMPLATE, {
            :script => script
          })
        else
          wlang_on_page(env, "convert")
        end
      rescue Exception => ex
        _500_(env, ex.message + ex.backtrace.join("\n"))
      end
      
    end # class SchemaConverter
  end # module DotOrg
end # module DbAgile