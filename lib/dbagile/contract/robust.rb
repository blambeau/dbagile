module DbAgile
  
  # All errors related to the contract
  class ContractError < DbAgile::Error; end 
  
  # Raised when a table should not exists but does
  class TableAlreadyExistsError < ContractError; end
  
  # Raised when possible when a table does not exists
  class NoSuchTableError < ContractError; end
  
  # Raised when a key is violated
  class KeyViolationError < ContractError; end

  # Internal error used when transaction are aborted
  class AbordTransactionError < ContractError; end

end
require 'dbagile/contract/robust/helpers'
require 'dbagile/contract/robust/optimistic'