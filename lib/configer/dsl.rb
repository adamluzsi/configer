
module Configer

  module ObjectEXT

    def __config__
      ::Configer::Data.config_hash
    end;alias __CONFIG__ __config__

  end

end

Object.__send__ :include, Configer::ObjectEXT