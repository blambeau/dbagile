if RUBY_VERSION < "1.9"
  class Object
    def self.const_missing(name)
      if DbAgile::Plugin::const_defined?(name)
        DbAgile::Plugin::const_get(name)
      else
        super
      end
    end
  end
end