
module Configer

  ConfigObject= Class.new(::Hashie::Mash)
  module Data
    def self.config_hash
      @@config ||= ConfigObject.new
    end
  end

  class << self

    def new *args
      self::ConfigObject.new(*args)
    end

    alias :init :new

  end

end