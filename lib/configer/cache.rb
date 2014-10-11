module Configer
  module Cache
    class << self

      def object
        @dir ||= Configer.pwd
        if @dir == Configer.pwd
          return @cache ||= Object.parse(mount_all)
        else
          return @cache = Object.parse(mount_all)
        end
        
      end

    end
  end
end
