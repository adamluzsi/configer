module Configer

  module ObjectEXT

    def __config__
      ::Configer::Cache.object
    end;alias __CONFIG__ __config__

  end

end

Object.__send__ :include, Configer::ObjectEXT