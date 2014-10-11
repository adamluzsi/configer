module Configer
  class << self

    def mount_all
      return [

          mount_lib_meta,
          mount_lib_module_meta,

          mount_config,
          mount_config_environments

      ].reduce(Object.new){|m,o| m.deep_merge!(o) rescue nil ;m}
    end


  end
end