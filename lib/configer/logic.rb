module Configer

  module Helpers

    def supported_formats
      @formats ||= %W[ erb json yaml yml ]
    end

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
          return Object.parse(object)

        else
          return Object.parse({ 'data' => object })

      end

    rescue;{}
    end

    def name_parser(name_str)
      name_str.gsub(/(\.json|\.yaml|\.yml|\.erb)/,'')
    end

    #> opts:
    #
    # category:
    #   namespace where the gathered meta file datas will be merged
    #
    # split_at:
    #   string or regexp where the meta folder located
    def mount_process( *paths,break_if: -> e { e.size > 2 }, namespace_less: false )
      return paths.reduce(Object.new) do |m,file_path|

        if namespace_less
          m.deep_merge!(parser(file_path))
        else
          #> keys will be downcase anyways
          elements = []
          file_path.split(File::Separator).reverse.each do |element|
            next  if element =~ /^(META|meta)$/
            break if element =~ /^(config|libs?)$/

            elements.unshift element
            break if break_if.call(elements)

          end

          key_cains = []
          m.deep_merge!(
              elements.reduce(Object.new) do |mem,element|

                target_obj = mem
                key_cains.each{|k| target_obj = target_obj[k] }
                key_cains.push(element)

                if elements[-1] == element
                  target_obj[name_parser(element)] = parser(file_path)

                else
                  target_obj[name_parser(element)] ||= Object.new

                end;mem

              end
          )
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
              "*.{#{supported_formats.join(',')}}"
          )
      )

    end

    def mount_lib_module_meta

      mount_process(
          *Dir.glob(
              File.join(
                  Configer.pwd,
                  '{lib,libs}',
                  '*',
                  '{meta,META}',
                  '**',
                  "*.{#{supported_formats.join(',')}}"
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
                  "*.{#{supported_formats.join(',')}}"
              )
          ),
          break_if: -> e { e.size == 1 },
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
                  "#{Configer.env}.{#{supported_formats.join(',')}}"
              )
          ),
          break_if: -> { elements.size >= 1 },
          namespace_less: true

      )

    end

  end

  extend Helpers

end