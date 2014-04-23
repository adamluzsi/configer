
module Configer

  ConfigObject= Class.new(::Hashie::Mash)
  module Data
    def self.config_hash
      @@config ||= ConfigObject.new
    end
  end

end