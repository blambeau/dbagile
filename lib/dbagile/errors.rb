module DbAgile
  class Error < StandardError; end
  class CorruptedConfigFileError < DbAgile::Error; end
  class NoConfigFileError < DbAgile::Error; end
  class UnknownConfigurationError < DbAgile::Error; end
end