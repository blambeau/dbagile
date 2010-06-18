module DbAgile
  class Adapter
    class AdapterError < StandardError; end
    class KeyViolationError < AdapterError; end
    class AbordTransactionError < AdapterError; end
  end # class Adapter
end # module DbAgile