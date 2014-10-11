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
                      File.read(file_path)
                    end

      object = if file_path =~ /\.ya?ml(\.erb)?$/
                 require 'yaml'
                 #> back compatibility for old yaml parse logic
                 if YAML.respond_to?(:save_load)
                   YAML.safe_load(file_string)
                 else
                   YAML.load(file_string)
                 end

               elsif file_path =~ /\.json(\.erb)?$/
                 require 'json'
                 JSON.parse(file_string)

               else
                 file_string

               end


      return Object.parse(object)

    rescue;nil
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
          #> if some non matching type wanted to be merged
          m.deep_merge!(parser(file_path)) rescue nil
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

    def mount_lib_meta(get_pwd=Configer.pwd)

      mount_process(
          *Dir.glob(
              File.join(
                  get_pwd,
                  '{lib,libs}',
                  '{meta,META}',
                  '**',
                  "*.{#{supported_formats.join(',')}}"
              )
          )
      )

    end

    def mount_lib_module_meta(get_pwd=Configer.pwd)

      mount_process(
          *Dir.glob(
              File.join(
                  get_pwd,
                  '{lib,libs}',
                  '*',
                  '{meta,META}',
                  '**',
                  "*.{#{supported_formats.join(',')}}"
              )
          )
      )
    end

    def mount_config(get_pwd=Configer.pwd)

      mount_process(
          *Dir.glob(
              File.join(
                  get_pwd,
                  'config',
                  "*.{#{supported_formats.join(',')}}"
              )
          ),
          break_if: -> e { e.size == 1 },
          namespace_less: true
      )

    end

    def mount_config_environments(get_pwd=Configer.pwd)

      mount_process(
          *Dir.glob(
              File.join(
                  get_pwd,
                  'config',
                  '{environments,environment,env,envs}',
                  "#{Configer.env}.{#{supported_formats.join(',')}}"
              )
          ),
          break_if: -> e { e.size >= 1 },
          namespace_less: true
      )

    end

  end

  extend Helpers

end