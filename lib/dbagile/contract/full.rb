module DbAgile
  module Contract
    module Full
      include TransactionSupport
      include ConnectionDriven
      include TableDriven
      include TransactionDriven
    end # module Full
  end # module Contract
end # module DbAgile