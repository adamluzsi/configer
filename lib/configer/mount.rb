module Configer
  class << self

    def mount_all(get_pwd=Configer.pwd)
      return [

          mount_lib_meta(get_pwd),
          mount_lib_module_meta(get_pwd),

          mount_config(get_pwd),
          mount_config_environments(get_pwd)

      ].reduce(Object.new){|m,o| m.deep_merge!(o) rescue nil ;m}
    end


  end
end