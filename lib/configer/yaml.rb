
module Configer

  module YamlFN

    def mount_yaml_files opts= {}
      raise(ArgumentError) unless opts.class <= Hash
      require 'yaml'

      opts[:root] ||= opts.delete(:r) || opts.delete(:folder) || Dir.pwd
      opts[:out]  ||= opts.delete(:o) || opts.delete(:to)     || Configer::Data.config_hash

      raise unless opts[:out].class <= Hash
      unless opts[:out].class == Configer::ConfigObject
        opts[:out]= Configer::ConfigObject.new( opts[:out] )
      end

      Dir.glob( File.join( File.absolute_path(opts[:root]), "**","*.{yaml,yml}" ) ).each do |file_path|

        var= file_path.sub(opts[:root],"").split('.')
        var.pop
        var= var.join('.')

        path_elements= var.split(File::Separator)
        path_elements.delete('')

        tmp_hsh= {}
        current_obj= nil

        path_elements.count.times { |index|

          key_str= path_elements[index]
          (current_obj ||= tmp_hsh)
          current_obj[key_str]= {} #ConfigObject.new
          current_obj= current_obj[key_str] unless index == (path_elements.count-1)

        }

        current_obj[ path_elements.last ]= YAML.safe_load File.read file_path
        opts[:out].deep_merge!(tmp_hsh)

        return nil
      end

    end
    alias :mount_yaml :mount_yaml_files
    alias :mount_yml :mount_yaml_files

  end

  extend YamlFN

end