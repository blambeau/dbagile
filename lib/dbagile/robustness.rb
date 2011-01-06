module DbAgile
  
  # Main class of all DbAgile errors
  class Error < StandardError; end
  
  # Raised when something goes really wrong (a bug, typically)
  class InternalError < DbAgile::Error; end
  
  # Some internal assumption failed
  class AssumptionFailedError < DbAgile::InternalError; end
  
end
require 'dbagile/robustness/file_system'
require 'dbagile/robustness/dependencies'