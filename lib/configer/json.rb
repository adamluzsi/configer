
module Configer

  module JSONFN

    def mount_json_files opts= {}
      raise(ArgumentError) unless opts.class <= Hash
      require 'json'

      [:r,:folder,:dir,:directory].each do |sym|
        opts[:root] ||= opts.delete(sym)
      end
      opts[:root] ||=  Configer.pwd

      opts[:out]  ||= opts.delete(:o) || opts.delete(:to) || Configer::Object
      raise(ArgumentError,"out/to must point to hashlike object") unless opts[:out].class <= ::Hash
      opts[:out].__send__ :extend, HashExtension unless opts[:out].respond_to?(:deep_merge!)

      Dir.glob( File.join( File.absolute_path(opts[:root]), "**","*.{json}" ) ).each do |file_path|

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
          current_obj[key_str]= {}
          current_obj= current_obj[key_str] unless index == (path_elements.count-1)

        }

        current_obj[ path_elements.last ]= JSON.parse File.read file_path

        opts[:out].deep_merge!(tmp_hsh)

        return nil
      end

    end
    alias :mount_json  :mount_json_files

  end

  extend JSONFN

end