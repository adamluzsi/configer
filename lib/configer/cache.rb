module Configer
  module Cache

    module Logic

      def get_pwd
        Configer.pwd
      end

      def mount_all
        Configer.mount_all
      end

      def object
        @dir ||= get_pwd
        if @dir == get_pwd
          return @cache ||= Object.parse(mount_all)
        else
          @dir = get_pwd
          return @cache = Object.parse(mount_all)
        end

      end

    end

    extend Logic

  end
end
