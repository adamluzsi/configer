# require 'loader'
require 'hashie'

module Configer

  ConfigObject= Class.new(::Hashie::Mash)

  module Data
    def self.config_hash
      @@config ||= ConfigObject.new
    end
  end

  module YamlFN

    def mount_yaml_files opts= {}
      raise(ArgumentError) unless opts.class <= Hash
      require 'yaml'

      opts[:root] ||= opts[:r] || opts[:root_folder] || Dir.pwd

      #root_folder= ::Loader.caller_root

      Dir.glob( File.join( File.absolute_path(opts[:root]), "**","*.{yaml,yml}" ) ).each do |file_path|

        var= file_path.sub(opts[:root],"").split('.')
        var.pop
        var= var.join('.')

        path_elements= var.split(File::Separator)
        path_elements.delete('')

        tmp_hsh= ConfigObject.new
        current_obj= nil

        path_elements.each { |key_str|

          (current_obj ||= tmp_hsh)
          current_obj[key_str]= ConfigObject.new
          current_obj= current_obj[key_str]

        }

        current_obj= YAML.safe_load File.read file_path
        Data.config_hash.deep_merge!(tmp_hsh)

      end

    end
    alias :mount_yaml :mount_yaml_files
    alias :mount_yml :mount_yaml_files

  end

  module JSONFN

    def mount_json_files opts= {}
      raise(ArgumentError) unless opts.class <= Hash
      require 'json'

      opts[:root] ||= opts[:r] || opts[:root_folder] || Dir.pwd

      #root_folder= ::Loader.caller_root

      Dir.glob( File.join( File.absolute_path(opts[:root]), "**","*.{json}" ) ).each do |file_path|

        var= file_path.sub(opts[:root],"").split('.')
        var.pop
        var= var.join('.')

        path_elements= var.split(File::Separator)
        path_elements.delete('')

        tmp_hsh= ConfigObject.new
        current_obj= nil

        path_elements.each { |key_str|

          (current_obj ||= tmp_hsh)
          current_obj[key_str]= ConfigObject.new
          current_obj= current_obj[key_str]

        }

        current_obj= JSON.parse File.read file_path
        puts tmp_hsh
        Data.config_hash.deep_merge!(tmp_hsh)

      end

    end
    alias :mount_json  :mount_json_files

  end

  extend YamlFN
  extend JSONFN

  module ObjectEXT

    def configer
      ::Configer::Data.config_hash
    end

    alias :config :configer

  end

end

Object.__send__ :include, Configer::ObjectEXT