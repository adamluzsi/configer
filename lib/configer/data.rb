
module Configer

  class Object < ::Hashie::Mash
  end

  module Data
    def self.config_hash
      @@config ||= Object.new
    end
  end

  class << self

    def new *args
      self::Object.new(*args)
    end

    alias :init :new

  end

end