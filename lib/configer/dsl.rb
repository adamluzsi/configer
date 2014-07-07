
module Configer

  module ObjectEXT

    def configer
      ::Configer::Data.config_hash
    end

    alias :__config__ :configer
    alias :__CONFIG__ :configer

  end

end

Object.__send__ :include, Configer::ObjectEXT