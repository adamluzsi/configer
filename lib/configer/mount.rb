module Configer

  module Mounter

    module Helpers

      def parser(file_path)

        file_string = if file_path.downcase =~ /\.erb\.?/
                        require 'erb'
                        ERB.new(File.read(file_path)).result
                      else
                        file_string = File.read(file_path)
                      end

        object = if file_path =~ /\.ya?ml$/
                   require 'yaml'
                   if YAML.respond_to?(:save_load)
                     YAML.safe_load(file_string)
                   else
                     YAML.load(file_string)
                   end

                 elsif file_path =~ /\.json$/
                   require 'json'
                   JSON.parse(file_string)

                 else
                   file_string

                 end

        case object

          when Hash
            return object

          else
            return { 'data' => object }

        end

      rescue;{}
      end

      #> opts:
      #
      # category:
      #   namespace where the gathered meta file datas will be merged
      #
      # split_at:
      #   string or regexp where the meta folder located
      def mount_process( *paths,break_if: -> { elements.size > 2 }, namespace_less: false )
        return paths.reduce(Object.new) do |m,file_path|

          #> keys will be downcase anyways
          elements = []
          file_path.split(File::Separator).reverse.each do |element|
            next  if element =~ /^(META|meta)$/
            break if element => /^(config|libs?)$/
            elements.push element
            break if break_if.call

          end

          if namespace_less
            m.merge!(parser(file_path))
            next
          end

          if elements.size == 2
            m.deep_merge!(
                elements[0]=> {
                    elements[1].split('.')[0] => parser(file_path)
                }
            )
          else
            m.deep_merge!(elements[0]=> parser(file_path))
          end;m

        end
      end

      def mount_lib_meta

        mount_process *Dir.glob(
            File.join(
                Configer.pwd,
                '{lib,libs}',
                '{meta,META}',
                '**',
                '*.{yml,yaml,json}'
            )
        )

      end

      def mount_lib_module_meta

        mount_process(
            *Dir.glob(
                File.join(
                    Configer.pwd,
                    '{lib,libs}',
                    '**',
                    '{meta,META}',
                    '*.{yml,yaml,json}'
                )
            )
        )


      end

      def mount_config

        mount_process(

            *Dir.glob(
                File.join(
                    Configer.pwd,
                    'config',
                    '**',
                    '*.{yml,yaml,json}'
                )
            ),
            break_if: -> { elements.size == 1 },
            namespace_less: true

        )

      end

      def mount_config_environments

        mount_process(

            *Dir.glob(
                File.join(
                    Configer.pwd,
                    'config',
                    '{environments,environment,env,envs}',
                    "#{Configer.env}.{yml,yaml,json}"
                )
            ),
            break_if: -> { elements.size >= 1 },
            namespace_less: true

        )

      end

    end

    extend Helpers

    def self.mount_config
      return [

          mount_lib_meta,
          mount_lib_module_meta,

          mount_config,
          mount_config_environments
      ].reduce(Object.new){|m,o| m.merge!(o) rescue nil ;m}
    end

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