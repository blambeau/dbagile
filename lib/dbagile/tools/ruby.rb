module DbAgile
  module RubyTools
    
    # Makes a call to a block that accepts optional arguments
    def optional_args_block_call(block, args)
      if RUBY_VERSION >= "1.9.0"
        if block.arity == 0
          block.call
        else
          block.call(*args)
        end
      else
        block.call(*args)
      end
    end
    
    extend(RubyTools)
  end # module RubyTools
end # module DbAgile