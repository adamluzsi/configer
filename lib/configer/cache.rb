module Configer
  module Cache
    class << self

      def object
        @dir ||= Configer.pwd
        if @dir == Configer.pwd
          return @cache ||= Object.parse(Configer.mount_all)
        else
          @dir = Configer.pwd
          return @cache = Object.parse(Configer.mount_all)
        end

      end

    end
  end
end
