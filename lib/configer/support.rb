module Configer

  def self.pwd

    if defined?(Rails) && !(Rails.root.nil?)
      return Rails.root.to_s
    else
      return Dir.pwd.to_s
    end

  end

  module Support

    #> return mounted config objects
    def self.mount_config_and_lib_meta

      return_hash = {}
      return_hash.__send__ :extend, HashExtension

      config_yaml_paths= []
      config_yaml_paths.instance_eval do
        def push_path(*paths)
          paths.each do |path|
            case true

              when path.downcase.include?('default')
                self.insert 0, path

              when path.downcase.include?('development')
                self.insert 1, path

              when path.downcase.include?('test')
                self.insert 2, path

              when path.downcase.include?('production')
                self.insert 3, path

              else
                self.push path

            end
          end
        end;alias push_paths push_path
      end

      #> load lib meta folders files
      if File.exist?(File.join(Configer.pwd,'lib'))
        config_yaml_paths.push_paths *Dir.glob(File.join(Configer.pwd,'lib','**','{meta,META}','*.{yaml,yml,json}'))
        config_yaml_paths.push_paths *Dir.glob(File.join(Configer.pwd,'lib','{meta,META}','**','*.{yaml,yml,json}'))
        config_yaml_paths.compact!
      end

      #> load config folder
      if File.exist?(File.join(Configer.pwd,'config'))

        config_yaml_paths.push_paths *Dir.glob(File.join(Configer.pwd,'config','*.{yaml,yml,json}'))
        if File.exist?(File.join(Configer.pwd,'config','environments'))
          config_yaml_paths.push_paths *Dir.glob(File.join(Configer.pwd,'config','environments','*.{yaml,yml,json}'))
        end
        config_yaml_paths.compact!

      end

      config_yaml_paths.each do |path|

        path_parts = path.split(File::Separator)

        extension = path_parts.last.split('.')[-1]

        category_key = case

                         #> lib/meta/*
                         when path_parts[-2].downcase == 'meta' && path_parts[-3] == 'lib'
                           nil

                         #> lib/meta/**/*
                         when path_parts[-3].downcase == 'meta' && path_parts[-4] == 'lib'
                           path_parts[-2]

                         #> lib/**/meta/*
                         when path_parts[-2].downcase == 'meta' && path_parts[-3] != 'lib' && path_parts[-4] == 'lib'
                           path_parts[-3]

                         else
                           nil

                       end

        object = if %W[ yaml yml ].include?(extension)
                   require 'yaml'

                   if YAML.respond_to?(:save_load)
                     YAML.safe_load(File.read(path))
                   else
                     YAML.load(File.read(path))
                   end

                 elsif extension == 'json'
                   require 'json'
                   JSON.parse(File.read(path))
                 else
                   {}
                 end

        if path.downcase.include?('meta')
          object = {
              ( path_parts.last.split('.')[-2] || path ) => object
          }
        end

        if category_key.nil?
          return_hash.deep_merge!(object)
        else
          return_hash.deep_merge!(category_key => object)
        end

      end

      return return_hash

    end


  end
end