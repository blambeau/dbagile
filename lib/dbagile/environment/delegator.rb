module DbAgile
  class Environment
    #
    # Helper to be an environment delegator
    #
    module Delegator
      
      [
        #
        :say,
        :display,
        #
        :console_width,
        :console_width=,
        #
        :config_file_path,
        :config_file_path=,
        #
        :config_file,
        #
        :history_file_path,
        :history_file_path=,
        #
        :input_buffer,
        :input_buffer=,
        #
        :output_buffer,
        :output_buffer=,
        #
        :with_config_file,
        :with_config,
        :with_current_database,
        #
        :with_connection,
        :with_current_connection
      ].each do |method_name|
        if method_name.to_s =~ /=$/
          code = <<-EOF
            def #{method_name}(value)
              environment.#{method_name} value
            end
          EOF
        else
          code = <<-EOF
            def #{method_name}(*args, &block)
              environment.#{method_name}(*args, &block)
            end
          EOF
        end
        module_eval(code)
      end
    
    end # module Delegator
  end # class Environment
end # module DbAgile