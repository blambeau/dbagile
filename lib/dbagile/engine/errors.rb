module DbAgile
  class Engine
    class EngineError < StandardError; end
    class InvalidCommandError < StandardError; end
    class NoSuchCommandError < StandardError; end

    class NoPendingTransactionError < StandardError; end
    
    class NoSuchTableError < StandardError; end
    class NoSuchColumnError < StandardError; end

    NoDatabaseError = EngineError.new("No database selected. Please connect first!")
  end # class Engine
end # module DbAgile